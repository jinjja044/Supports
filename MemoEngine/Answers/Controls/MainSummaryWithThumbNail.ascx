<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MainSummaryWithThumbNail.ascx.cs" Inherits="MemoEngine.Answers.Controls.MainSummaryWithThumbNail" %>

<div class="row">
    <% 
        for (int i = 0; i < Model.Count; i++)
        {
    %>
    <div class="col-md-3 col-sm-3 text-center" style="height: 120px;">
        <img src="/Answers/ThumbNail.aspx?FileName=<%= Model[i].FileName %>&Width=100&Height=100" alt="<%= Model[i].Title %>" 
            class="img-thumbnail" />
        <br />
        <a href="/Answers/AnswerDetails.aspx?Id=<%= Model[i].Id %>">
            <%= Model[i].Title %><br />
        </a>
    </div>
    <%
        }
    %>
</div>
