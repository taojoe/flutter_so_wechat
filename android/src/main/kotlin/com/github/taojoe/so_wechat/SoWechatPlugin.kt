package com.github.taojoe.so_wechat

import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull;
import com.github.taojoe.so_wechat.helper.ReqHelper
import com.github.taojoe.so_wechat.helper.RespHelper
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** SoWechatPlugin */
public class SoWechatPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    init(flutterPluginBinding.binaryMessenger, flutterPluginBinding.applicationContext)
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    val METHOD_CHANNEL_NAME="com.github.taojoe.so_wechat/method"
    val STREAM_CHANNEL_NAME="com.github.taojoe.so_wechat/stream"

    private lateinit var methodChannel : MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var context: Context
    private var wxapi: IWXAPI? = null

    private fun init(messenger: BinaryMessenger, context: Context){
      methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
      methodChannel.setMethodCallHandler(SoWechatPlugin())
      eventChannel = EventChannel(messenger, STREAM_CHANNEL_NAME).apply {
        setStreamHandler(object :EventChannel.StreamHandler{
          override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink= events
          }

          override fun onCancel(arguments: Any?) {
            eventSink=null
          }
        })
      }
      this.context = context
    }

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      init(registrar.messenger(), registrar.context())
    }

    fun wxapiHandleIntent(intent: Intent?){
      if(intent!=null){
        wxapi?.handleIntent(intent,  object : IWXAPIEventHandler {
          override fun onResp(resp: BaseResp?) {
            val data= if(resp!=null) RespHelper.respToMap(resp) else null
            if(data!=null){
              eventSink?.success(data)
            }
          }

          override fun onReq(p0: BaseReq?) {
          }
        })
      }
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val send_prefix="send"
    if (call.method == "initApi") {
      val appId:String?=call.argument("appId")
      if(wxapi==null){
        wxapi=WXAPIFactory.createWXAPI(context.applicationContext, appId)
      }
      result.success(true)
    } else if(call.method.startsWith(send_prefix)) {
      val name=call.method.substring(send_prefix.length)
      val req=ReqHelper.dataToReq(name, call.arguments<Map<String, Any?>>())
      if(req!=null){
        result.success(wxapi!!.sendReq(req))
      }else{
        result.notImplemented()
      }
    }else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    wxapi=null
  }
}
