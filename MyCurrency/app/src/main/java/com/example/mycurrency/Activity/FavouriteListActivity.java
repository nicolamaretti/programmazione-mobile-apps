package com.example.mycurrency.Activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.mycurrency.Adapter.FavouriteListAdapter;
import com.example.mycurrency.Adapter.OnItemClickListener;
import com.example.mycurrency.Model.Favourite;
import com.example.mycurrency.Model.FavouriteList;
import com.example.mycurrency.R;
import com.google.android.material.appbar.MaterialToolbar;

import java.util.ArrayList;

public class FavouriteListActivity extends AppCompatActivity {
    private MaterialToolbar toolbar;
    private RecyclerView recyclerView;
    private ArrayList<Favourite> favouriteList;
    private FavouriteListAdapter favouriteListAdapter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_favourite_list);

        initUI();
    }

    private void initUI() {
        favouriteList = FavouriteList.getInstance().getAll();

        // TOOLBAR
        toolbar = findViewById(R.id.toolbar);
        toolbar.setTitle("Favourites");
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

        if(favouriteList.size() == 0) {
            // TEXTVIEW IF EMPTY
            Toast.makeText(this, "No favourites to show", Toast.LENGTH_SHORT).show();
        }

        favouriteListAdapter = new FavouriteListAdapter(getApplicationContext(), new OnItemClickListener() {
            @Override
            public void onItemClick(Favourite favourite) {
                //Toast.makeText(FavouritesListActivity.this, "Item clicked: " + favourite.getFrom() + " - " + favourite.getTo(), Toast.LENGTH_SHORT).show();

                Intent resultIntent = new Intent();
                resultIntent.putExtra("favouriteSelected", favourite);
                setResult(Activity.RESULT_OK, resultIntent);
                finish();
            }
        });

        recyclerView = findViewById(R.id.recyclerView);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setHasFixedSize(true);
        recyclerView.setAdapter(favouriteListAdapter);
        recyclerView.setVisibility(View.VISIBLE);
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        Intent resultIntent = new Intent();
        setResult(Activity.RESULT_CANCELED, resultIntent);
        finish();
    }
}