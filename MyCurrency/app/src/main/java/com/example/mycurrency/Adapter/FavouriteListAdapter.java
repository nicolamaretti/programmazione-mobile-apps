package com.example.mycurrency.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.example.mycurrency.Model.Favourite;
import com.example.mycurrency.Model.FavouriteList;
import com.example.mycurrency.R;

public class FavouriteListAdapter extends RecyclerView.Adapter<FavouriteListAdapter.FavouriteViewHolder> {
    private FavouriteList favouriteList;
    private Context context;
    private OnItemClickListener listener;

    public FavouriteListAdapter(Context context, OnItemClickListener listener) {
        this.favouriteList = FavouriteList.getInstance();
        this.context = context;
        this.listener = listener;
    }

    @NonNull
    @Override
    public FavouriteViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        // create a new view
        View view = LayoutInflater.from(context).inflate(R.layout.favourite_item_layout, parent, false);

        return new FavouriteViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull FavouriteViewHolder holder, int position) {
        // - get element from your dataset at this position
        Favourite favourite = favouriteList.get(position);

        // - replace the contents of the view with that element
        holder.bind(favourite, this);

        holder.itemView.setOnClickListener(v -> {
            listener.onItemClick(favourite);
        });
    }

    @Override
    public int getItemCount() {
        return favouriteList.size();
    }

    public static class FavouriteViewHolder extends RecyclerView.ViewHolder {
        private TextView tv_item_from;
        private TextView tv_item_to;
        private ImageButton ibtn_delete_favourite;

        public FavouriteViewHolder(@NonNull View view) {
            super(view);
            tv_item_from = view.findViewById(R.id.tv_item_from);
            tv_item_to = view.findViewById(R.id.tv_item_to);
            ibtn_delete_favourite = view.findViewById(R.id.ibtn_delete_favourite);
        }

        public void bind(Favourite favourite, FavouriteListAdapter adapter) {
            if(favourite != null) {
                tv_item_from.setText(favourite.getFrom());
                tv_item_to.setText(favourite.getTo());
                ibtn_delete_favourite.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        int index = FavouriteList.getInstance().indexOf(favourite);

                        FavouriteList.getInstance().remove(favourite);

                        adapter.notifyItemRemoved(index);
                    }
                });
            }
        }
    }
}