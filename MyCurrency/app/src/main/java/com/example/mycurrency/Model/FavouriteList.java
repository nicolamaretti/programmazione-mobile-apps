package com.example.mycurrency.Model;

import java.util.ArrayList;

public class FavouriteList {
    private ArrayList<Favourite> favourites;
    private static FavouriteList instance;

    private FavouriteList() {
        this.favourites = new ArrayList<>();
    }

    public static FavouriteList getInstance() {
        if(instance == null) {
            instance = new FavouriteList();
        }

        return instance;
    }

    public Favourite get(int index) {
        return favourites.get(index);
    }

    public int indexOf(Favourite favourite) {
        return favourites.indexOf(favourite);
    }

    public ArrayList<Favourite> getAll() {
        return favourites;
    }

    public void add(Favourite favourite) {
        favourites.add(favourite);
    }

    public boolean remove(Favourite favourite) {
        if(favourites.remove(favourite))
            return true;
        return false;
    }

    public int size() {
        return favourites.size();
    }
}
