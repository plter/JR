package com.plter.jr.server;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;

import javax.el.MethodNotFoundException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * AJJServer
 * @author xtiqin
 *
 */
public class JRServer{
	
	
	private HttpServletRequest request;
	public HttpServletRequest getRequest() {
		return request;
	}

	private HttpServletResponse response;
	
	public HttpServletResponse getResponse() {
		return response;
	}
	
	private String jsonStr;

	/**
	 * 获取客户端发送来的原始JSON数据
	 * @return
	 */
	public String getJsonStr() {
		return jsonStr;
	}
	
	private JSONObject json;

	/**
	 * 取得客户端发来的JSON对象
	 * @return
	 */
	public JSONObject getJson() {
		return json;
	}
	
	private Hashtable<String, Class<?>> classMap=new Hashtable<String, Class<?>>();
	private Hashtable<String, Class<?>> voMap=new Hashtable<String, Class<?>>();

	public JRServer(HttpServletRequest request,HttpServletResponse response) throws JSONException{
		this.request=request;
		this.response=response;
		
		
		jsonStr=request.getParameter("method");
		if (jsonStr!=null) {
			json=new JSONObject(jsonStr);
		}
	}
	
	/**
	 * 添加一个类
	 * @param classRef	类的引用
	 * @param className 类的名字，字符串中不能包含"."
	 */
	public void addClass(Class<?> classRef,String className){
		classMap.put(className, classRef);
	}
	
	/**
	 * 注册VO
	 * @param classRef 类的引用，该类必须为ValueObject或者其子类
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public void registerValueObject(Class<?> classRef) throws InstantiationException, IllegalAccessException{
		ValueObject vo=(ValueObject)(classRef.newInstance());
		voMap.put(vo.alias, classRef);
	}
	
	/**
	 * 处理客户端请求
	 * @return
	 * @throws Exception
	 */
	public String handle() throws Exception{
		if(json==null){
			return "JR server running...<br/>Powered by xtiqin,website:<a href=\"http://plter.com\">http://plter.com</a>";
		}
		
		String methodName=(String)json.get("name");
		JSONArray args=(JSONArray)json.get("args");
		
		int len=args.length();
		Object[] params=new Object[len];
		for (int i = 0; i < len; i++) {
			Object arg=args.get(i);
			if(arg instanceof JSONObject&&((JSONObject) arg).has("alias")){
				arg=convertValueObject((JSONObject)arg);
			}
			params[i]=arg;
		}
		
		Method[] methods=null;
		Method method=null;
		JSONObject resultObj=new JSONObject();
		String[] methodNameInfoArr=methodName.split("\\.");
		Class<?> classRef=null;
		
		switch(methodNameInfoArr.length){
		case 1:
			classRef=getClass();
			break;
		case 2:
			classRef=classMap.get(methodNameInfoArr[0]);
			methodName=methodNameInfoArr[1];
			break;
		}
		
		if(classRef==null){
			throw new Exception("Not supported");
		}
		
		methods=classRef.getMethods();
		ArrayList<Method> namedMethods=new ArrayList<Method>();
		for (Method m : methods) {
			if(m.getName().equals(methodName)){
				namedMethods.add(m);
			}
		}
		
		int size=namedMethods.size();
		if(size<1){
			throw new MethodNotFoundException("Can not found method \""+methodName+"\" on class \""+classRef.getName()+"\"");
		}else if(size==1){
			method=methods[0];
		}else{
			for (Method namedMethod : namedMethods) {
				Class<?>[] argTypes=namedMethod.getParameterTypes();
				if(argTypes.length==params.length){
					int sameArgCount=0;
					for (int i = 0; i < argTypes.length; i++) {
						Class<?> argType=argTypes[i];
						Object param=params[i];
						Class<?> paramType=param.getClass();
						if(argType.equals(paramType)||
								(paramType.equals(Integer.class)&&(argType.equals(int.class)||argType.equals(long.class)))||
								(paramType.equals(Double.class)&&argType.equals(double.class))){
							
							sameArgCount++;
						}
					}
					if(sameArgCount==argTypes.length){
						method=namedMethod;
						break;
					}
				}
				
			}
		}
		
		if(method==null){
			throw new MethodNotFoundException("Can not found method \""+methodName+"\" on class \""+classRef.getName()+"\"");
		}

		resultObj.put("result", method.invoke(classRef==getClass()?this:classRef.newInstance(), params));
		return resultObj.toString();
	}
	
	private Object convertValueObject(JSONObject vo) throws JSONException, InstantiationException, IllegalAccessException{
		Class<?> classRef=voMap.get(vo.get("alias"));
		
		ValueObject returnVo=classRef!=null?(ValueObject)classRef.newInstance():new ValueObject();
		Class<?> returnVoClass=returnVo.getClass();
		Iterator<Object> keys=vo.keys();
		while(keys.hasNext()){
			String key=(String)keys.next();
			try{
				Object value=vo.get(key);
				if(value!=null&&value instanceof JSONObject&&((JSONObject)value).has("alias")){
					value=convertValueObject((JSONObject)value);
				}
				returnVoClass.getField(key).set(returnVo, value);
			}catch(NoSuchFieldException e){
				
			}
		}
		returnVo.refresh();
		return returnVo;
	}
}
