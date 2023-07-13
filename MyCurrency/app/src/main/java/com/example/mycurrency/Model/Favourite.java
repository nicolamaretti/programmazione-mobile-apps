package com.example.mycurrency.Model;

import android.os.Parcel;
import android.os.Parcelable;

import androidx.annotation.NonNull;

public class Favourite implements Parcelable {
    private String from;
    private String to;

    public Favourite(String from, String to) {
        this.from = from;
        this.to = to;
    }

    public String getFrom() {
        return from;
    }

    public String getTo() {
        return to;
    }

    // Parcelable methods
    protected Favourite(Parcel in) {
        from = in.readString();
        to = in.readString();
    }

    public static final Creator<Favourite> CREATOR = new Creator<Favourite>() {
        @Override
        public Favourite createFromParcel(Parcel in) {
            return new Favourite(in);
        }

        @Override
        public Favourite[] newArray(int size) {
            return new Favourite[size];
        }
    };

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(@NonNull Parcel parcel, int i) {
        parcel.writeString(from);
        parcel.writeString(to);
    }
}