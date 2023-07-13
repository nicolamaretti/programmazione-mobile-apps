package com.example.mycurrency.Model;

import java.time.LocalDate;

public class Rate {
    private LocalDate date;
    private Float rate;

    public Rate(LocalDate date, float rate) {
        this.date = date;
        this.rate = rate;
    }

    public LocalDate getDate() {
        return date;
    }

    public Float getRate() {
        return rate;
    }
}