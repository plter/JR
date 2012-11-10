<%@page import="com.plter.jr.test.vo.MyVO1"%>
<%@page import="com.plter.jr.test.vo.MyVO"%>
<%@page import="com.plter.jr.test.vo.VOServer"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%
VOServer server=new VOServer(request,response);
server.registerValueObject(MyVO.class);
server.registerValueObject(MyVO1.class);
out.clear();
out.print(server.handle());
%>