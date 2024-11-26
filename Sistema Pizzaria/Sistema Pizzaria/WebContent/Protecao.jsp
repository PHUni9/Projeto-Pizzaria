<%
if (session.getAttribute("nome")==null){
	response.sendRedirect("PageLogin.jsp");
}
%>