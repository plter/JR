<%@page import="com.plter.jr.server.JRServer"%>
<%@page import="com.plter.jr.test.classserver.HelloClass"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<%


JRServer server=new JRServer(request,response);
server.addClass(HelloClass.class,"HelloClass");
out.clear();
out.print(server.handle());
%>

