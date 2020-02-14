package com.github.taojoe.so_wechat.helper

import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelpay.PayResp

object RespHelper {
    private fun objectToMap(obj:Any):Map<String,  Map<String, Any?>>{
        val map= mutableMapOf<String, Any?>()
        for(field in obj.javaClass.fields){
            var value=field.get(obj)
            if(value!=null && !(value is Boolean || value is Int || value is Long || value is Double || value is String)){
               value=value.toString()
            }
            map[field.name]=value
        }
        return mapOf(obj.javaClass.simpleName to map.toMap())
    }
    fun respToMap(baseResp: BaseResp):Map<String, Map<String, Any?>>?{
        if(baseResp is PayResp){
            return objectToMap(baseResp)
        }
        return null
    }
}
