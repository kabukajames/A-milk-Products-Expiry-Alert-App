namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\QrCode;

class QrCodeController extends Controller
{
    public function index()
    {
        $qrCodes = QrCode::all();
        return response()->json($qrCodes);
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'qr_code' => 'required|string',
            'category' => 'required|string',
            'quantity' => 'required|integer',
            'brand' => 'required|string',
            'description' => 'nullable|string',
             'expried_at' => 'nullable|string',

        ]);

        $qrCode = QrCode::create($validatedData);
        return response()->json($qrCode, 201);
    }

    public function update(Request $request, QrCode $qrCode)
    {
        $validatedData = $request->validate([
            'qr_code' => 'required|string',
            'category' => 'required|string',
            'quantity' => 'required|integer',
            'brand' => 'required|string',
            'description' => 'nullable|string',
             'expried_at' => 'nullable|string',
        ]);

        $qrCode->update($validatedData);
        return response()->json($qrCode, 200);
    }

    public function destroy(QrCode $qrCode)
    {
        $qrCode->delete();
        return response()->json(null, 204);
    }
}
