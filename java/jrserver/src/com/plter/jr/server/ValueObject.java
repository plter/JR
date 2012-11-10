package com.plter.jr.server;

import java.lang.reflect.Field;
import java.util.HashMap;

public class ValueObject extends HashMap<String, Object>{
	
	private static final long serialVersionUID = 1L;

	public ValueObject() {
		refresh();
	}
	
	/**
	 * 刷新数据
	 */
	public void refresh(){
		Object value=null;
		
		for (Field f : getClass().getFields()) {
			try {
				value=f.get(this);
			} catch (Exception e) {
				value=null;
			} 
			put(f.getName(), value);
		}
	}
	
	public String alias="ValueObject";
}
