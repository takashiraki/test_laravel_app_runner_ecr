<?php

declare(strict_types=1);

namespace App\Http\Controllers\Email;

use App\Http\Controllers\Controller;
use App\Http\Requests\Email\SendEmailRequest;
use App\Mail\SendMailTest;
use Illuminate\Support\Facades\Mail;

class SendEmailController extends Controller
{
    public function handle(SendEmailRequest $http_request)
    {
        $status = Mail::to($http_request->input('email'))
            ->send(new SendMailTest()) !== null
        ? true : false;

        return view(
            'email.complete-send-email',
            [
                'status' => $status,
            ]
        );
    }
}
