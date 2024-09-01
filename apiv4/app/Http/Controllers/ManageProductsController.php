<?php

namespace App\Http\Controllers;


use App\Models\Products;
use Illuminate\Http\Request;

class ManageProductsController extends Controller
{
   // Fetch all products ordered by id in descending order
public function index()
{
    $products = Products::orderBy('id', 'desc')->get();
    return response()->json($products);
}


    // Store a new product
    public function store(Request $request)
    {
        $request->validate([
            'code' => 'required|string|unique:products',
            'category' => 'required|string',
            'quantity' => 'required|integer',
            'brand' => 'required|string',
            'description' => 'required|string',
            'expired_at' => 'required|string',
            'volume' => 'required|numeric',
        ]);

        $product = Products::create($request->all());
        return response()->json($product, 201);
    }

    // Update an existing product
    public function update(Request $request, $id)
    {
        $product = Products::findOrFail($id);

        $request->validate([
            'code' => 'required|string|unique:products,code,' . $product->id,
            'category' => 'required|string',
            'quantity' => 'required|integer',
            'brand' => 'required|string',
            'description' => 'required|string',
            'expired_at' => 'required|string',
            'volume' => 'required|numeric',
        ]);

        $product->update($request->all());
        return response()->json($product, 200);
    }

    // Delete a product
    public function destroy($id)
    {
        $product = Products::findOrFail($id);
        $product->delete();
        return response()->json(null, 204);
    }



     // Show a specific product
    public function show($id)
    {
        $product = Products::findOrFail($id);
        return response()->json($product);
    }


    public function countProducts()
{
    // Count the number of products
    $productCount = Products::count();

    return response()->json(['product_count' => $productCount], 200);
}


}
