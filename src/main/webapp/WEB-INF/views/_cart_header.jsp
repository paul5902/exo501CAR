<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<pre>
Panier :

<c:choose>
  <c:when test="${cart.articles.size() > 0 }">
	<c:forEach var="article" items="${cart.articles}">
	   * ${article.name} - <fmt:formatNumber type = "number" minFractionDigits="2" maxFractionDigits = "2" value = "${article.price / 100.0 }" /> €
	</c:forEach>
  </c:when>
  <c:otherwise>
	Aucun article
  </c:otherwise>
</c:choose>

</pre>
<a class="btn btn-primary" href="cart/1/validate.html">Commander</a>
