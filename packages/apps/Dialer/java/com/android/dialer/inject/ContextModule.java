/*
 * Copyright (C) 2017 The Android Open Source Project
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
 * limitations under the License
 */

package com.android.dialer.inject;

import android.content.Context;
import android.support.annotation.NonNull;
import com.android.dialer.common.Assert;
import dagger.Module;
import dagger.Provides;

/** Provides the singleton context object. */
@Module
public final class ContextModule {

  @NonNull private final Context context;

  public ContextModule(@NonNull Context context) {
    this.context = Assert.isNotNull(context);
  }

  @Provides
  Context provideContext() {
    return context;
  }
}
