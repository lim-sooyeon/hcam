<%@page import="java.util.TreeMap"%>
<%@page import="dao.CommonDAO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean class="dao.CommonDAO" id="commonDao"></jsp:useBean>
<jsp:useBean class="dao.HcamFileDAO" id="fileDao"></jsp:useBean>
<%
	//로그인한 회원정보
	String id = (String) session.getAttribute("id");
	// 세션에 저장된 mem_no 값 가져오기 
	int mem_no = 0;
	if(session.getAttribute("mem_no") != null) {
		mem_no = Integer.parseInt(String.valueOf(session.getAttribute("mem_no")));
	}
	String mem_name = "";
	if(session.getAttribute("mem_name") != null) {
		mem_name = String.valueOf(session.getAttribute("mem_name"));
	}
	
	/* 코드별 공통코드 전체 조회 */
	TreeMap<String, String> commCodes = commonDao.getCodeAllByCode("CHT01");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script>
	/* init window */
	$(document).ready(function(){
		fn_callPdRight();
	});

	$(function() {
		/* 오른쪽 tab */
		$('ul.inner_tab_tit li').click(function() {
			
			var inner_onTab = $(this).attr('data-tab');
			$('ul.inner_tab_tit li').removeClass('inner_on');
			$('.inner_cnt').removeClass('inner_on');
			$(this).addClass('inner_on');
			$('#' + inner_onTab).addClass('inner_on');
	
		})
	});
	
	/* 콤보박스 클릭 시 오른쪽 영역 재호출 */
	function fn_callPdRight() {
		var pdCtgy = document.getElementsByName("pdCtgy")[0];
		var pdCtgy_value = "day";
		
		if(pdCtgy.value == "CHT01001") {
			pdCtgy_value = "day";
		}
		else if(pdCtgy.value == "CHT01002") {
			pdCtgy_value = "month";
		}
		
		$.ajax({
			url: "view/HCAM_mgrpagePeroidRight.jsp",
			type:'POST',
			dataType: "text",
			async:false,
			data: "mgr_no=" + <%=mem_no %> + 
		  	  	  "&date_kubun=" + pdCtgy_value,
			success: function(result) {
				$(".right_chart").html(result);
			},
			error: function(request, error) {
				alert(request.status + " / " + request.responseText + " / " + error);
			}
		});
	}
</script>
<body>
	<div class="right_inner">
		<div class="right_top">
			<div>기간별 예약내역</div>
			<div>(<%=mem_name %> 님으로 등록된 호텔, 렌터카 예약 내역)</div>
		</div>
		<div class="right_pdCombo">
			<span>(단위)</span>
			<select name="pdCtgy" onchange="fn_callPdRight();">
				<% 
					for(Map.Entry<String, String> code : commCodes.entrySet()) { 
						out.println("<option value='" + code.getKey() + "'>" + code.getValue() + "</option>");
					}
				%>
			</select>
			<span>조회조건: </span>
		</div>
		<div class="right_chart">
			
		</div>
	</div>
	
	<%
		commonDao.dbClose();
	%>
	
</body>
</html>