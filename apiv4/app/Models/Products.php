<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Products extends Model
{
    use HasFactory;
     protected $fillable = ['code', 'category', 'quantity', 'brand', 'description', 'expired_at','volume'];
}
