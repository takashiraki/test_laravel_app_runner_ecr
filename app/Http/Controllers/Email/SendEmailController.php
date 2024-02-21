<?php

declare(strict_types=1);

namespace App\Http\Controllers\Email;

use App\Http\Controllers\Controller;
use App\Http\Requests\Email\SendEmailRequest;

class SendEmailController extends Controller
{
    public function handle(SendEmailRequest $http_request)
    {
        $mail_headers = [
            'MIME-Version' => '1.0',
            'Content-Transfer-Encoding' => '7bit',
            'Content-Type' => 'text/plain; charset=UTF-8',
            'Return-Path' => 'from@example.com',
            'From' => 'SenderName <from@example.com>',
            'Sender' => 'SenderName <from@example.com>',
            'Reply-To' => 'from@example.com',
            'Organization' => 'OrganizationName',
            'X-Sender' => 'from@example.com',
            'X-Mailer' => 'Postfix/2.10.1',
            'X-Priority' => '3',
        ];

        $status = mb_send_mail(
            $http_request->input('email'),
            'Test mail',
            'This is a test mail.',
            $mail_headers
        );

        return view(
            'email.complete-send-email',
            [
                'status' => $status,
            ]
        );
    }
}
