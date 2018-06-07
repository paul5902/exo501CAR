<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="_header.jsp"%>

<h1>Liste des commandes</h1>

<c:choose>
 	<c:when test="${orders.size() > 0 }">
		<c:forEach var="order" items="${orders}">
			   <p><fmt:formatDate pattern = "d/M/YY" value = "${order.createdOn}" /></p>
			   <p><fmt:formatNumber type = "number" minFractionDigits="2" maxFractionDigits = "2" value ="${order.amount / 100.0 }" /> €</p>
			   <p>${order.currentStatus}</p>
		</c:forEach>
	</c:when>
	<c:otherwise>
		Pas de commande
	</c:otherwise>
</c:choose>


<%@include file="_footer.jsp"%>