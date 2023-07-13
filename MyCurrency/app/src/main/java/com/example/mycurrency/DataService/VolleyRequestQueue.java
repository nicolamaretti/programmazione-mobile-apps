package com.example.mycurrency.DataService;

import android.content.Context;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;

public final class VolleyRequestQueue {
    private static VolleyRequestQueue instance;
    private RequestQueue requestQueue;
    private static Context context;

    private VolleyRequestQueue(Context context) {
        this.context = context;
        requestQueue = getRequestQueue();
    }

    public static synchronized VolleyRequestQueue getInstance(Context context) {
        if(instance == null) {
            instance = new VolleyRequestQueue(context);
        }

        return instance;
    }

    public synchronized RequestQueue getRequestQueue() {
        if (requestQueue == null) {
            // getApplicationContext() is key, it keeps you from leaking the
            // Activity or BroadcastReceiver if someone passes one in.
            requestQueue = Volley.newRequestQueue(context.getApplicationContext());
        }
        return requestQueue;
    }

    public <T> void addToRequestQueue(Request<T> req) {
        getRequestQueue().add(req);
    }

}
