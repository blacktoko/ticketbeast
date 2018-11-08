<?php

namespace App;

class Reservation
{
    private $tickets;

    public function __construct($tickets, $email)
    {
        $this->tickets = $tickets;
        $this->email = $email;
    }

    public function totalCost()
    {
        return $this->tickets->sum('price');
    }

    public function email()
    {
        return $this->email;
    }

    public function tickets()
    {
        return $this->tickets;
    }

    public function complete($paymentGateway, $paymenToken)
    {
        $paymentGateway->charge($this->totalCost(), $paymenToken);
        return Order::forTickets($this->tickets(), $this->email(), $this->totalCost());
    }

    public function cancel()
    {
        foreach ($this->tickets as $ticket) {
            $ticket->release();
        }
    }
}
