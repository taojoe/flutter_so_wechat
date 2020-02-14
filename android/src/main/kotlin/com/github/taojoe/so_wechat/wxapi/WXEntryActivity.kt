package com.github.taojoe.so_wechat.wxapi

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.github.taojoe.so_wechat.SoWechatPlugin

open class WXEntryActivity:Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        SoWechatPlugin.wxapiHandleIntent(intent)
        finish()
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        setIntent(intent)
        SoWechatPlugin.wxapiHandleIntent(intent)
        finish()
    }
}