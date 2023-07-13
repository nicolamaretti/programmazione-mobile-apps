package com.example.mycurrency.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.mycurrency.Model.Rate;
import com.example.mycurrency.R;

import java.util.ArrayList;

public class RateListAdapter extends RecyclerView.Adapter<RateListAdapter.RateViewHolder> {
    private ArrayList<Rate> rateDataSet;
    private Context context;

    public RateListAdapter(ArrayList<Rate> rateDataSet, Context context) {
        this.rateDataSet = rateDataSet;
        this.context = context;
    }

    @NonNull
    @Override
    public RateViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.rate_item_layout, parent, false);

        return new RateViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull RateListAdapter.RateViewHolder holder, int position) {
        // - get element from your dataset at this position
        Rate rate = rateDataSet.get(position);

        // - replace the contents of the view with that element
        holder.bind(rate);
    }

    @Override
    public int getItemCount() {
        return rateDataSet.size();
    }

    public static class RateViewHolder extends RecyclerView.ViewHolder {
        private TextView tv_date;
        private TextView tv_rate;

        public RateViewHolder(@NonNull View view) {
            super(view);
            tv_date = view.findViewById(R.id.tv_date);
            tv_rate = view.findViewById(R.id.tv_rate);
        }

        public void bind(Rate rate) {
            if(rate != null) {
                tv_date.setText(rate.getDate().toString());
                tv_rate.setText(rate.getRate().toString());
            }
        }
    }
}