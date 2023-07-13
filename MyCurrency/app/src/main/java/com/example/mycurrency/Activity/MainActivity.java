package com.example.mycurrency.Activity;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ProgressBar;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.example.mycurrency.DataService.CurrencyDataService;
import com.example.mycurrency.DataService.VolleyCurrenciesResponseListener;
import com.example.mycurrency.Model.Currency;
import com.example.mycurrency.Model.FavouriteList;
import com.example.mycurrency.Model.Favourite;
import com.example.mycurrency.R;
import com.google.android.material.appbar.MaterialToolbar;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity {
    /// UI Elements
    private MaterialToolbar toolbar;
    private ProgressBar progressBar;
    private ConstraintLayout constraintLayout;
    private Spinner spn_from;
    private Spinner spn_to;
    private ImageButton ibtn_swap;
    private Button btn_convert;
    private Button btn_add_to_favourites;
    private TextView tv_amount_code;
    private TextView tv_result_code;
    private EditText etn_amount;
    private EditText etn_result;

    /// Data
    private ArrayList<String> currencyCodes;
    private ArrayList<Float> currencyValues;
    private CurrencyDataService currencyDataService;
    private FavouriteList favourites;
    private int itemPositionFrom;
    private int itemPositionTo;

    /// Test
//    private ArrayList<String> currenciesString = new ArrayList<>();

    // gestione del risultato dell'activity lanciata
    private ActivityResultLauncher<Intent> getActivityResult = registerForActivityResult(new ActivityResultContracts.StartActivityForResult(),
            new ActivityResultCallback<ActivityResult>() {
                @Override
                public void onActivityResult(ActivityResult result) {
                    if(result.getResultCode() == Activity.RESULT_OK) {
                        Favourite favourite = result.getData().getParcelableExtra("favouriteSelected");

                        spn_from.setSelection(currencyCodes.indexOf(favourite.getFrom()));
                        spn_to.setSelection(currencyCodes.indexOf(favourite.getTo()));
//                        spn_from.setSelection(currenciesString.indexOf(favourite.getFrom()));
//                        spn_to.setSelection(currenciesString.indexOf(favourite.getTo()));
                    }
                    else if(result.getResultCode() == Activity.RESULT_CANCELED) {
                        // se è stato premuto il back button, empty
                    }
                }
            });

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        currencyDataService = CurrencyDataService.getInstance(this);

        currencyCodes = new ArrayList<>();
        currencyValues = new ArrayList<>();

        favourites = FavouriteList.getInstance();

        /// Test
//        currenciesString = new ArrayList<>();
//        currenciesString.add("EUR");
//        currenciesString.add("USD");
//        currenciesString.add("BTC");
//        currenciesString.add("BNB");
//
//        favourites.add(new Favourite("EUR", "USD"));
//        favourites.add(new Favourite("USD", "BTC"));
//        favourites.add(new Favourite("BNB", "EUR"));
//        favourites.add(new Favourite("BNB", "BTC"));

        initUI();

        /// Test
//        initContent();

        loadCurrencies();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_layout, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();

        if (id == R.id.action_show_favourites) {
            showFavourites();
        }

        if (id == R.id.action_show_rates) {
            showRates();
        }

        return super.onOptionsItemSelected(item);
    }

    private void loadCurrencies() {
        currencyDataService.getCurrencies(new VolleyCurrenciesResponseListener() {
            @Override
            public void onResponse(ArrayList<Currency> response) {
                for (Currency currency : response) {
                    currencyCodes.add(currency.getCode());
                    currencyValues.add(currency.getValue());
                }

                initContent();
            }

            @Override
            public void onError(String message) {
                Toast.makeText(MainActivity.this, message, Toast.LENGTH_SHORT).show();

                initContent();
            }
        });
    }

    private void initUI() {
        toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        progressBar = findViewById(R.id.progressBarMain);
    }

    private void initContent() {
        progressBar.setVisibility(View.GONE);

        constraintLayout = findViewById(R.id.constraintLayoutMain);
        constraintLayout.setVisibility(View.VISIBLE);

        /// AMOUNT
        tv_amount_code = findViewById(R.id.tv_amount_code);
        etn_amount = findViewById(R.id.etn_amount);

        /// FROM
        spn_from = findViewById(R.id.spn_from);
        ArrayAdapter spn_from_adapter = createAdapter();
        // Apply the adapter to the spinner
        spn_from.setAdapter(spn_from_adapter);
        spn_from.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {

            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                tv_amount_code.setText(spn_from.getSelectedItem().toString());
                itemPositionFrom = position;
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                // Empty
            }
        });

        /// IMAGE BUTTON SWAP
        ibtn_swap = findViewById(R.id.ibtn_swap);
        ibtn_swap.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                swapButtonClicked();
            }
        });

        /// RESULT
        tv_result_code = findViewById(R.id.tv_result_code);
        etn_result = findViewById(R.id.etn_result);

        /// TO
        spn_to = findViewById(R.id.spn_to);
        ArrayAdapter spn_to_adapter = createAdapter();
        // Apply the adapter to the spinner
        spn_to.setAdapter(spn_to_adapter);
        spn_to.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {

            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                tv_result_code.setText(spn_to.getSelectedItem().toString());
                itemPositionTo = position;
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                // Empty
            }
        });

        /// BUTTON CONVERT
        btn_convert = findViewById(R.id.btn_convert);
        btn_convert.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                convertButtonClicked();
            }
        });

        /// BUTTON FAVOURITES
        btn_add_to_favourites = findViewById(R.id.btn_add_to_favourites);
        btn_add_to_favourites.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                addToFavouritesButtonClicked();
            }
        });
    }

    private ArrayAdapter createAdapter() {
        // Create an ArrayAdapter using the string array and a default spinner layout
        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, currencyCodes);

        /// Test
//        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, currenciesString);


        // Specify the layout to use when the list of choices appears
        adapter.setDropDownViewResource(com.google.android.material.R.layout.support_simple_spinner_dropdown_item);

        return adapter;
    }

    private boolean addFavourite() {
        // creo il nuovo oggetto Favourite e lo aggiungo alla lista
        String from = spn_from.getSelectedItem().toString();
        String to = spn_to.getSelectedItem().toString();

        Favourite favourite = new Favourite(from, to);

        favourites.add(favourite);

        Toast.makeText(this, "Favourite added correctly", Toast.LENGTH_SHORT).show();

        return true;
    }

    private boolean showFavourites() {
        Intent intent = new Intent(getApplicationContext(), FavouriteListActivity.class);

        getActivityResult.launch(intent);

        return true;
    }

    private boolean showRates() {
        String from = spn_from.getSelectedItem().toString();
        String to = spn_to.getSelectedItem().toString();

        Intent intent = new Intent(getApplicationContext(), RateListActivity.class);

        intent.putExtra("currencyFrom", from);
        intent.putExtra("currencyTo", to);

        getActivityResult.launch(intent);

        return true;
    }

    private void swapButtonClicked() {
        swap();
    }

    private void convertButtonClicked() {
        String amountString = etn_amount.getText().toString();

        // calcolo
        float result = convert(amountString);

        // display del risultato
        this.etn_result.setText(String.valueOf(result));

        hideSoftKeyBoard();
    }

    private void addToFavouritesButtonClicked() {
        addFavourite();
    }

    private void swap() {
        spn_from.setSelection(itemPositionTo);
        spn_to.setSelection(itemPositionFrom);
    }

    private float convert(String amountString) {
        float conversionRateFrom = currencyValues.get(itemPositionFrom);
        float conversionRateTo = currencyValues.get(itemPositionTo);

        float amount = Float.parseFloat(amountString);

        return amount * conversionRateTo / conversionRateFrom;
    }

    private void hideSoftKeyBoard() {
        InputMethodManager imm = (InputMethodManager) getSystemService(INPUT_METHOD_SERVICE);


        if(imm.isAcceptingText()) { // verify if the soft keyboard is open
            imm.hideSoftInputFromWindow(getCurrentFocus().getWindowToken(), 0);
        }
    }
}