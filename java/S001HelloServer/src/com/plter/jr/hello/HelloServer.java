package com.plter.jr.hello;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;

import com.plter.jr.server.JRServer;

public class HelloServer extends JRServer {

	public HelloServer(HttpServletRequest request, HttpServletResponse response)
			throws IOException, JSONException {
		super(request, response);
	}
	
	public String hello(String name){
		return "Hello "+name;
	}
	
	public String hello(){
		return "Hello world";
	}
	
	public String hello(String name,int id){
		return "Hello "+name+",id="+id;
	}
	
	

}
