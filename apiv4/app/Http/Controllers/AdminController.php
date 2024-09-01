<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class AdminController extends Controller
{



public function register(Request $request)
{
    $validatedData = $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|string|email|max:255|unique:users',
        'password' => 'required|string|min:8',
        'role' => 'required|string|max:255',
    ]);

    $validatedData['password'] = bcrypt($validatedData['password']);

    $user = User::create($validatedData);

    if ($user) {
        return response()->json(['message' => 'User created successfully', 'user' => $user], 201);
    } else {
        return response()->json(['message' => 'Internal server error'], 500);
    }
}


public function login(Request $request)
{
    $credentials = $request->validate([
        'email' => 'required|string|email',
        'password' => 'required|string|min:8',
    ]);

    if (!Auth::attempt($credentials)) {
        return response()->json(['message' => 'Invalid credentials'], 401);
    }

    $user = $request->user();

    // Check if the user role is admin
    if ($user->role !== 'admin') {
        Auth::logout(); // Logout the user
        return response()->json(['message' => 'Unauthorized. Only admins can login'], 401);
    }

    $token = $user->createToken('authToken')->plainTextToken;

    return response()->json(['user' => $user, 'token' => $token]);
}



    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json(['message' => 'Logged out']);
    }



public function updatePassword(Request $request)
    {
        // Ensure the user is authenticated
        if (!$request->user()) {
            return response()->json(['message' => 'Unauthenticated'], 401);
        }

        $request->validate([
            'email' => 'required|email',
            'current_password' => 'required|string',
            'new_password' => 'required|string|min:8',
        ]);

        $user = Auth::user();

        // Check if the provided email matches the authenticated user's email
        if ($user->email !== $request->email) {
            return response()->json(['message' => 'Invalid email'], 401);
        }

        // Check if the current password matches the user's hashed password
        if (!Hash::check($request->current_password, $user->password)) {
            return response()->json(['message' => 'Current password is incorrect'], 401);
        }

        // Update the user's password
        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json(['message' => 'Password updated successfully'], 200);
    }


public function getLoggedUserName(Request $request)
{
    // Ensure the user is authenticated
    if (!$request->user()) {
        return response()->json(['message' => 'Unauthenticated'], 401);
    }

    $user = $request->user();

    return response()->json(['email' => $user->email]);
}

 public function getUsersOrderedByIdDesc()
    {
        // Fetch users ordered by ID in descending order
        $users = User::orderByDesc('id')->get();

        return response()->json(['users' => $users]);
    }




    public function editUser(Request $request, $id)
{
    // Find the user by ID
    $user = User::find($id);

    if (!$user) {
        return response()->json(['message' => 'User not found'], 404);
    }

    // Validate the request data
    $validatedData = $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|string|email|max:255|unique:users,email,' . $user->id,
        'role' => 'required|string|max:255',
    ]);

    // Update the user with the validated data
    $user->update($validatedData);

    return response()->json(['message' => 'User updated successfully', 'user' => $user]);
}



public function deleteUser($id)
{
    // Find the user by ID
    $user = User::find($id);

    if (!$user) {
        return response()->json(['message' => 'User not found'], 404);
    }

    // Delete the user
    $user->delete();

    return response()->json(['message' => 'User deleted successfully']);
}




public function getUserById($id)
{
    try {
        $user = User::findOrFail($id); // Fetch the user by ID
        return response()->json($user, 200);
    } catch (\Exception $e) {
        return response()->json(['error' => 'Internal Server Error: ' . $e->getMessage()], 500);
    }
}

}
