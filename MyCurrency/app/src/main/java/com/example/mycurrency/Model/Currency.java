package com.example.mycurrency.Model;

public class Currency {
    private String code;
    private float value;

    public Currency(String code, float value) {
        this.code = code;
        this.value = value;
    }

    public String getCode() {
        return code;
    }

    public float getValue() {
        return value;
    }
}
