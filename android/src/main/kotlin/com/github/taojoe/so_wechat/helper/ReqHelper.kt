package com.github.taojoe.so_wechat.helper

import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelpay.PayReq


object ReqHelper {
    fun dataToReq(name: String, arguments: Map<String, Any?>): BaseReq? {
        if(name=="PayReq"){
            val ret=PayReq()
            ret.appId = arguments["appId"].toString()
            ret.partnerId = arguments["partnerId"].toString()
            ret.prepayId = arguments["prepayId"].toString()
            ret.packageValue = arguments["packageValue"].toString()
            ret.nonceStr = arguments["nonceStr"].toString()
            ret.timeStamp = arguments["timeStamp"].toString()
            ret.sign = arguments["sign"].toString()
            ret.signType = arguments["signType"].toString()
            ret.extData = arguments["extData"].toString()
            return ret
        }
        return null
    }
}