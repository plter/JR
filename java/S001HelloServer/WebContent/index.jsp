<%@page import="com.plter.jr.hello.HelloServer"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
HelloServer server=new HelloServer(request,response);
out.clear();
out.print(server.handle());

%>