package com.plter.jr.test.vo;

import com.plter.jr.server.ValueObject;

public class MyVO extends ValueObject {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public MyVO() {
		alias="MyVO";
		refresh();
	}
	
	public MyVO1 myVO1;
	
	public String data;
}
