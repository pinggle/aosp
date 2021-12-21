/*
 * Copyright (C) 2016 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package android.support.v4.app;

import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;

class HostCallbacks extends FragmentHostCallback<FragmentActivity> {
    private final FragmentActivity mActivity;

    HostCallbacks(FragmentActivity activity, Handler handler, int windowAnimations) {
        super(activity, handler, windowAnimations);
        mActivity = activity;
    }

    @Override
    public FragmentActivity onGetHost() {
        return mActivity;
    }

    @Override
    public View onFindViewById(int id) {
        return mActivity.findViewById(id);
    }

    @Override
    public LayoutInflater onGetLayoutInflater() {
        return mActivity.getLayoutInflater().cloneInContext(mActivity);
    }

}
