package com.plter.jr.test.vo;

import com.plter.jr.server.ValueObject;

public class MyVO1 extends ValueObject {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public MyVO1() {
		alias="MyVO1";
		refresh();
	}
	
	public String data;
}
