package com.example.mycurrency.Activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.mycurrency.Adapter.RateListAdapter;
import com.example.mycurrency.DataService.CurrencyDataService;
import com.example.mycurrency.DataService.VolleyHistoricalResponseListener;
import com.example.mycurrency.Model.Rate;
import com.example.mycurrency.R;
import com.google.android.material.appbar.MaterialToolbar;

import java.time.LocalDate;
import java.util.ArrayList;

public class RateListActivity extends AppCompatActivity {
    /// UI Elements
    private MaterialToolbar toolbar;
    private RecyclerView recyclerViewShowRates;
    private ProgressBar progressBar;

    /// Data
    private ArrayList<Rate> rateList;
    private CurrencyDataService currencyDataService;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rate_list);

        initUI();
    }

    private void initUI() {
        toolbar = findViewById(R.id.toolbar);
        toolbar.setTitle("Last 7 days rates");
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent resultIntent = new Intent();
                setResult(Activity.RESULT_CANCELED, resultIntent);
                finish();
            }
        });

        progressBar = findViewById(R.id.progressBarShowRates);

        loadRates();
    }

    private void loadRates() {
        String currencyFrom = (String) getIntent().getSerializableExtra("currencyFrom");
        String currencyTo = (String) getIntent().getSerializableExtra("currencyTo");

        // data di ieri
        LocalDate dateTo = LocalDate.now().minusDays(1);

        // 7 giorni fa
        LocalDate dateFrom = dateTo.minusDays(6);

        // request
        currencyDataService = CurrencyDataService.getInstance(getApplicationContext());

        currencyDataService.getHistoricalRates(currencyFrom, currencyTo, dateFrom, dateTo, new VolleyHistoricalResponseListener() {
            @Override
            public void onResponse(ArrayList<Rate> rateListResponse) {
                rateList = rateListResponse;

                createRecyclerView();

                progressBar.setVisibility(View.GONE);
            }

            @Override
            public void onError(String message) {
                progressBar.setVisibility(View.GONE);

                Toast.makeText(RateListActivity.this, message, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void createRecyclerView() {
        RateListAdapter rateListAdapter = new RateListAdapter(rateList, getApplicationContext());

        recyclerViewShowRates = findViewById(R.id.recyclerViewShowRates);
        recyclerViewShowRates.setLayoutManager(new LinearLayoutManager(getApplicationContext()));
        recyclerViewShowRates.setHasFixedSize(true);
        recyclerViewShowRates.setAdapter(rateListAdapter);
        recyclerViewShowRates.setVisibility(View.VISIBLE);
    }
}