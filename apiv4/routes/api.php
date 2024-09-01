<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\ManageProductsController;
use App\Http\Controllers\AdminController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});



Route::apiResource('/products', ManageProductsController::class);
Route::get('/product/count', [ManageProductsController::class, 'countProducts']);


Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout']);
Route::post('/update-password', [AuthController::class, 'updatePassword']);
Route::get('/useremail', 'App\Http\Controllers\AuthController@getLoggedUserName');
Route::get('users', [AuthController::class, 'getAllUsers']);
Route::get('/users/count', [AuthController::class, 'countUsers']);


//admin routes
Route::post('/registerV1', [AdminController::class, 'register']);
Route::post('/loginV1', 'App\Http\Controllers\AdminController@login')->name('login');
Route::middleware('auth:sanctum')->post('/logoutV1', [AdminController::class, 'logout']);
Route::middleware('auth:sanctum')->post('/update-passwordV1', [AdminController::class, 'updatePassword']);
Route::middleware('auth:sanctum')->get('/user/nameV1', 'App\Http\Controllers\AdminController@getLoggedUserName');

