package com.example.mycurrency.DataService;

import com.example.mycurrency.Model.Rate;

import java.util.ArrayList;

public interface VolleyHistoricalResponseListener {
    public void onResponse(ArrayList<Rate> rateList);

    public void onError(String message);
}
