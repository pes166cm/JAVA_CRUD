<%@page import="vo.MoneyVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.ThisDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	ThisDAO dao = new ThisDAO();
	ArrayList<MoneyVO> list = dao.getListT();
%>    
<jsp:include page="/master/header.jsp"/>
<section>
	<p id="table_title">회원매출조회</p>
	<table>
		<% if(list != null){ %>
		<tr>
			<td>회원번호</td>
			<td>회원성명</td>
			<td>고객등급</td>
			<td>매출</td>
		</tr>
		
		<% for(MoneyVO money : list){ %>
		
		<tr>
			<td><%=money.getCustno() %></td>
			<td><%=money.getCustname() %></td>
			<td><%=money.getGrade()  %></td>
			<td><%=money.getPrice() %></td>
		</tr>
		<% } %>
		
	</table>

	<% } else{ 
		out.print("등록된 매출 정보가 없습니다.");
	} %>
</section>
<jsp:include page="/master/footer.jsp"/>