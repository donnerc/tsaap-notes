%{--
  - Copyright 2013 Tsaap Development Group
  -
  - Licensed under the Apache License, Version 2.0 (the "License");
  - you may not use this file except in compliance with the License.
  - You may obtain a copy of the License at
  -
  -    http://www.apache.org/licenses/LICENSE-2.0
  -
  - Unless required by applicable law or agreed to in writing, software
  - distributed under the License is distributed on an "AS IS" BASIS,
  - WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  - See the License for the specific language governing permissions and
  - limitations under the License.
  --}%



<html xmlns="http://www.w3.org/1999/html">
<head>
  <meta name="layout" content="main"/>
  <r:require modules="tsaap_ui_notes,tsaap_icons"/>
</head>

<body>
<div class="container note-edition">
  <g:if test="${note?.hasErrors()}">
    <div class="alert alert-danger">
      <g:eachError bean="${note}">
        <li><g:message error="${it}"/></li>
      </g:eachError>
    </div>
  </g:if>
  <g:form method="post" controller="notes" action="addNote">
    <g:hiddenField name="contextId" value="${context?.id}"
                   id="contextIdInAddForm"/>
    <g:hiddenField name="displaysMyNotes" id="displaysMyNotesInAddForm"/>
    <g:hiddenField name="displaysMyFavorites"
                   id="displaysMyFavoritesInAddForm"/>
    <g:hiddenField name="displaysAll" id="displaysAllInAddForm"/>
    <textarea class="form-control" rows="3" id="noteContent" name="noteContent"
              maxlength="280"
              value="${fieldValue(bean: note, field: 'content')}"></textarea>
    <span id="character_counter"></span><button type="submit"
                                                class="btn btn-primary btn-xs pull-right"><span
            class="glyphicon glyphicon-plus"></span> Add note</button>
  </g:form>
</div>

<div class="divider"></div>

<div class="container note-list">
  <div class="note-list-header">
    <g:if test="${context}">
      <div class="note-list-context pull-left">
        <button type="button" class="btn btn-default btn-xs"
                id="button_context">
          ${context.contextName}
        </button>
      </div>
    </g:if>
    <div class="note-list-selector pull-right">
      <g:form controller="notes" action="index" method="get">
        <g:hiddenField name="contextId" value="${context?.id}"/>
        <label class="checkbox-inline">
          <g:checkBox name="displaysMyNotes" checked="${displaysMyNotes}"
                      onchange="submit();"/> My notes
        </label>
        <label class="checkbox-inline">
          <g:checkBox name="displaysMyFavorites"
                      checked="${displaysMyFavorites}"
                      onchange="submit();"/> My favorites
        </label>
        <label class="checkbox-inline">
          <g:if test="${context}">
          <g:checkBox name="displaysAll" checked="${displaysAll}"
                      onchange="submit();"/>  All
          </g:if>
          <g:else>
            <input type="checkbox" name="displaysAll" disabled/> <span style="color: gainsboro">All</span>
          </g:else>
        </label>
      </g:form>
    </div>
  </div>

  <div class="note-list-content">
    <ul class="list-group">
      <g:each in="${notes.list}" var="note">
        <li class="list-group-item" style="padding-bottom: 20px">
          <g:set var="noteIsBookmarked" value="${note.isBookmarkedByUser(user)}"/>
          <h6 class="list-group-item-heading"><strong>${note.author.fullname}</strong> <small>@${note.author.username}</small>

            <g:if test="${note.context}">
              <span class="badge">
                <g:if test="${context}">
                  ${note.context.contextName}
                </g:if>
                <g:else>
                  <g:link controller="notes" action="index"
                          params='[contextId:"${note.contextId}",displaysMyNotes:"${displaysMyNotes ? 'on' : ''}",displaysMyFavorites:"${displaysMyFavorites ? 'on' : ''}", displaysAll:"${displaysAll ? 'on' : ''}"]'>${note.context.contextName}
                  </g:link>
                </g:else>
              </span>
            </g:if>
            <small class="pull-right"><g:formatDate date="${note.dateCreated}"
                                                    type="datetime" style="LONG"
                                                    timeStyle="SHORT"/></small>
            <g:if test="${noteIsBookmarked}"><span class="pull-right glyphicon glyphicon-star" style="color: orange; padding-right: 5px;"></span> </g:if>

          </h6>

          <p>${note.content}</p>

          <small class="pull-right">
            <a href="#"><span
                    class="glyphicon glyphicon-share"></span> Reply</a>
            <g:if test="${noteIsBookmarked}">
              <g:link style="color: orange" controller="notes" action="unbookmarkNote" params='[noteId:"${note.id}",contextId:"${context ? context.id :''}",displaysMyNotes:"${displaysMyNotes ? 'on' : ''}",displaysMyFavorites:"${displaysMyFavorites ? 'on' : ''}", displaysAll:"${displaysAll ? 'on' : ''}"]'><span
                                  class="glyphicon glyphicon-star"></span> Favorite</g:link>
            </g:if>
            <g:else>
            <g:link controller="notes" action="bookmarkNote" params='[noteId:"${note.id}",contextId:"${context ? context.id :''}",displaysMyNotes:"${displaysMyNotes ? 'on' : ''}",displaysMyFavorites:"${displaysMyFavorites ? 'on' : ''}", displaysAll:"${displaysAll ? 'on' : ''}"]'><span
                    class="glyphicon glyphicon-star"></span> Favorite</g:link>
            </g:else>
          </small>
        </li>
      </g:each>
    </ul>
  </div>

  <div class="note-list-pagination">
    <tsaap:paginate class="pull-right" prev="&laquo;" next="&raquo;" total="${notes.totalCount}" params='[contextId:"${context ? context.id :''}",displaysMyNotes:"${displaysMyNotes ? 'on' : ''}",displaysMyFavorites:"${displaysMyFavorites ? 'on' : ''}", displaysAll:"${displaysAll ? 'on' : ''}"]'/>
  </div>
</div>
<g:if test="${context}">
  <r:script>
  $('#button_context').popover({
                                 title: "${context.contextName}",
                                 content: "<p><strong>url</strong>: <a href='${context.url}' target='blank'>${context.url}</a></p><p>${context.descriptionAsNote}</p>",
                                 html: true
                               })

  </r:script>
</g:if>
<r:script>
  jQuery(document).ready(function ($) {

    // set character counters
    //-----------------------

    // Get the textarea field
    $('#noteContent')

      // Bind the counter function on keyup and blur events
            .bind('keyup blur', function () {
                    // Count the characters and set the counter text
                    $('#character_counter').text($(this).val().length + '/280 characters');
                  })

      // Trigger the counter on first load
            .keyup();

    // set hidden field value
    //----------------------
    $('#displaysMyNotesInAddForm').val($("#displaysMyNotes").attr('checked') ? 'on' : '');
    $('#displaysMyFavoritesInAddForm').val($("#displaysMyFavorites").attr('checked') ? 'on' : '');
    $('#displaysAllInAddForm').val($("#displaysAll").attr('checked') ? 'on' : '');

  });
</r:script>

</body>
</html>