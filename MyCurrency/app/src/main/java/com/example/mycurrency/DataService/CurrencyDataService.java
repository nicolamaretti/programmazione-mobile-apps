package com.example.mycurrency.DataService;

import android.content.Context;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;

import com.example.mycurrency.Model.Currency;
import com.example.mycurrency.Model.Rate;

import org.json.JSONException;
import org.json.JSONObject;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Iterator;

public final class CurrencyDataService {
    public static final String API_QUERY_LATEST = "https://api.freecurrencyapi.com/v1/latest?apikey=4V6WQqm7tfICKncTZo5rkluc5nzuaiTP1PePY34a";
    public static final String API_QUERY_HISTORICAL = "https://api.freecurrencyapi.com/v1/historical?apikey=4V6WQqm7tfICKncTZo5rkluc5nzuaiTP1PePY34a";
    private static CurrencyDataService instance;
    private Context context;

    private CurrencyDataService(Context context) {
        this.context = context;
    }

    public static synchronized CurrencyDataService getInstance(Context context) {
        if(instance == null) {
            instance = new CurrencyDataService(context);
        }

        return instance;
    }

    public void getCurrencies(VolleyCurrenciesResponseListener volleyCurrenciesResponseListener) {
        String url = API_QUERY_LATEST;

        ArrayList<Currency> currencies = new ArrayList<>();

        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                try {
                    JSONObject dataObject = response.getJSONObject("data");

                    // prendo le chiavi delle currency nel json
                    Iterator iterator = dataObject.keys();

                    while(iterator.hasNext()) {
                        String code = iterator.next().toString();

                        String valueString = dataObject.getString(code);

                        float value = Float.parseFloat(valueString);

                        // creo la currency
                        Currency currency = new Currency(code, value);

                        currencies.add(currency);
                    }

                    volleyCurrenciesResponseListener.onResponse(currencies);
                } catch (JSONException e) {
                    throw new RuntimeException(e);
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                volleyCurrenciesResponseListener.onError("Error fetching currencies.");
            }
        });

        VolleyRequestQueue.getInstance(context).addToRequestQueue(request);
    }

    public void getHistoricalRates(String currencyFrom, String currencyTo, LocalDate dateFrom, LocalDate dateTo, VolleyHistoricalResponseListener volleyHistoricalResponseListener) {
        String url = API_QUERY_HISTORICAL + "&currencies=" + currencyFrom + "," + currencyTo + "&date_from=" + dateFrom.toString() + "&date_to=" + dateTo.toString();

        // risultato da ritornare
        ArrayList<Rate> rateList = new ArrayList<>();

        // request
        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null, new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                try {
                    JSONObject dataObject = response.getJSONObject("data");

                    // prendo le chiavi delle currency nel json (le date)
                    Iterator iterator = dataObject.keys();

                    while(iterator.hasNext()) {
                        String dateString = iterator.next().toString();

                        // prendo l'oggetto relativo alla chiave
                        JSONObject singleDayObject = dataObject.getJSONObject(dateString);

                        // prendo il valore di currencyFrom e currencyTo
                        String currencyFromValueString = singleDayObject.getString(currencyFrom);
                        String currencyToValueString = singleDayObject.getString(currencyTo);

                        // converto le stringhe in float
                        float currencyFromValue = Float.parseFloat(currencyFromValueString);
                        float currencyToValue = Float.parseFloat(currencyToValueString);

                        // calcolo il tasso di cambio di quel giorno
                        float conversionRate = currencyToValue / currencyFromValue;

                        // converto la data
                        LocalDate date = LocalDate.parse(dateString);

                        Rate rate = new Rate(date, conversionRate);

                        // aggiungo in testa perche' le date sono in ordine crescente
                        rateList.add(0, rate);
                    }
                } catch (JSONException e) {
                    throw new RuntimeException(e);
                }

                volleyHistoricalResponseListener.onResponse(rateList);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                volleyHistoricalResponseListener.onError("Error fetching currencies.");
            }
        });

        VolleyRequestQueue.getInstance(context).addToRequestQueue(request);
    }
}