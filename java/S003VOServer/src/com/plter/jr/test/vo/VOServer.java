package com.plter.jr.test.vo;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;

import com.plter.jr.server.JRServer;

public class VOServer extends JRServer {

	public VOServer(HttpServletRequest request, HttpServletResponse response)
			throws IOException, JSONException {
		super(request, response);
		// TODO Auto-generated constructor stub
	}
	
	public MyVO sendVO(MyVO vo){
		vo.data="Hello client";
		vo.refresh();
		return vo;
	}

}
