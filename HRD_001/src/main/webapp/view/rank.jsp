<%@page import="java.util.ArrayList"%>
<%@page import="dao.IsDAO"%>
<%@page import="vo.RankVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	
	IsDAO dao = new IsDAO();
	ArrayList<RankVO> list = dao.rankList();
%>
<jsp:include page="/master/header.jsp"/>
<section>
	<h2 class="m">후보자 등수 조회</h2>
	<table>
		<tr>
			<td>후보자번호</td>
			<td>후보자이름</td>
			<td>정당이름</td>
			<td>득표수</td>
			<td>등위</td>
		</tr>
		<%
			if(list != null){
				for(RankVO vo : list){
					out.print("<tr>");
					out.print("<td>" + vo.getC_no() + "</td>");
					out.print("<td>" + vo.getC_name() + "</td>");
					out.print("<td>" + vo.getP_name() + "</td>");
					out.print("<td>" + vo.getTotal() + "</td>");
					out.print("<td>" + vo.getRank() + "</td>");
					out.print("</tr>");
				}
			}else{
				out.print("<tr><td colspan='5'>자료가 없습니다.</td></tr>");
			}
		%>
	</table>
</section>
<jsp:include page="/master/footer.jsp"/>