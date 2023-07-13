package com.example.mycurrency.DataService;

import com.example.mycurrency.Model.Currency;

import java.util.ArrayList;

public interface VolleyCurrenciesResponseListener {
    public void onResponse(ArrayList<Currency> response);

    public void onError(String message);
}
