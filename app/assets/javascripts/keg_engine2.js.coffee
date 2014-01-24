Array::diff = (a) ->
  @filter (i) ->
    not (a.indexOf(i) > -1)

fixHelper = (e, ui) ->
  ui.children().each ->
    $(@).width $(@).width()
    $(@).children().each ->
      $(@).width $(@).width()
  $(ui).closest("table").find("th").each ->
    $(@).width $(@).width()
  ui

$.fn.bind_sortable = ->
  $(@).sortable
    helper: fixHelper
    update: (event, ui) ->
      $.ajax
        type: "POST"
        data: $(@).sortable("serialize", { key: $(@).data("sortable-key")})
        url: $(@).data("sortable-url")
      $(@).parent().effect "highlight", {}, 2000

$.fn.convert_remote_links = ->
  $("[remote-links]").find("a").each ->
    $(@).attr("data-remote", "true") unless $(@).attr("href") is "#"

$.fn.bind_modal_data_url = ->
  $("[data-url]").each ->
    $(@).load_modal_data_url()

$.fn.load_modal_data_url = ->
  $(@).bind "click", ->
    el_id = "#" + $(@).data("controls-modal") + " .in_body"
    $(el_id).html ""
    $.ajax
      url: $(@).data("url")
      complete: (jqXHR) ->
        $(el_id).spin false
        $(el_id).html jqXHR.responseText

$.fn.concat_checkbox_text = ->
  $str = ""
  $(@).find("input[type='checkbox']:checked").each ->
    $str +=  "<span class='btn btn-mini'>" + $(@).parent().text() + "</span> "
  $str

$.fn.bind_collapsible_label = ->
  $switch = $($(@).data("collapsible-label"))
  $main_el = $($(@).data("collapsible-main"))
  $opt_el = $($(@).data("collapsible-opt"))

  $switch.addClass("switch")
  $main_el.hide()
  $opt_el.show()

  $switch.on
    click: ->
      $(@).toggleClass("open")
      if $(@).hasClass("open")
        $main_el.show()
        $opt_el.hide()
      else
        $main_el.hide()
        $opt_el.show()

$.fn.bind_checkboxes_clone = ->
  $el = $($(@).data("checkboxes-clone"))
  $new_id = $(@).data("checkboxes-clone-into")

  $str = $el.concat_checkbox_text()
  $new_el = $("<div class='controls' id='#{$new_id}' style='margin-top: 5px;'></div>").hide()
  $new_el.html($str)

  $new_el.insertBefore($el)

  $el.find("input[type='checkbox']").on
    click: ->
      $str = $el.concat_checkbox_text()
      $new_el.html($str)

$.fn.bind_boolean_value = ->
  $(@).on
    click: ->
      $(@).parent().find("a").removeClass("active")
      $hidden = $(@).parent().next("input[type='hidden']")

      $val = $(@).data("boolean-value")
      $hid_val = $hidden.val()

      if ("#{$val}" != "#{$hid_val}")
        $hidden.val($val)
        $(@).addClass("active")
      else
        $hidden.val("")

      $("form").submit()

$.fn.bind_ransack_btn = ->
  $(@).on
    click: ->
      $btn = $(@).data("ransack-btn")
      $el = $("[data-ransack-chk='#{$btn}']")
      $el.click()
      $("form").submit()

$.fn.bind_ransack_chk = ->
  $(@).on
    click: ->
      $group = $(@).data("ransack-group")
      $id = $(@).attr("id")
      $els = $("input[type='checkbox'][data-ransack-group='#{$group}']").not("##{$id}")
      $els.attr("checked", false)

$.fn.bind_switches = ->
  $(".switch").each ->
    $(@).bind "click", ->
      el = $("#" + $(@).data("switchable"))
      if $(@).hasClass("open")
        $(@).removeClass "open"
        $(@).addClass "closed"
        el.hide()
      else
        $(@).removeClass "closed"
        $(@).addClass "open"
        el.show()

bind_clearable_fields = ->
  $("[data-clearable-field]").each ->
    input = $(@)
    form = (if input.length > 0 then $(input[0].form) else $())
    link = $("<a href=\"#\" class=\"active_field_clear\"><i class='fa fa-times-circle'></i></a>")
    $(@).after link
    input.on
      change: ->
        form.submit()
      changeDate: ->
        form.submit()

    link.on
      click: ->
        input.val ""
        form.submit()

bind_filter_html_elements = ->
  $("[data-filter-html]").on "keyUp", ->
    q = $(@).val()
    src_tag = $(@).data("src-tag")
    dest_tag = $(@).data("dest-tag")
    src_class = $(@).data("src-class")

    reg = new RegExp(".*" + q, "i")
    els = $("#{src_tag}.#{src_class}")
    els.each ->
      str = $(@).html()
      id = "#" + $(@).attr("id").replace(src_tag + "_", dest_tag + "_")
      unless q is ""
        if str.match(reg)
          $(id).show()
        else
          $(id).hide()
      else
        $(id).show()

bind_button_urls = ->
  $("[data-button-url]").on "click", ->
    window.location = $(@).data("button-url")
    false

bind_datepicker = ->
  $('.datepicker').datepicker
    format: 'dd.mm.yyyy'
    weekStart: 1

$.fn.bind_counter = ->
  $data = $(@).data()
  if $data
    $data.timerEnd = ->
      if $data.timerend
        $f = $data.timerend
      else
        $f = ""
      eval $f
      false

    $data.startTime = $data.starttime
    $data.digitWidth = $data.digitwidth
    $data.digitHeight = $data.digitheight

    $(@).countdown($data)

$.fn.remove_fields = (link) ->
  $(link).prev("input[type=hidden]").val "1"
  $(link).closest(".fields").hide(400)

$.fn.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")

  $new_html = content.replace(regexp, new_id)

  if ($(link).data("parent-selector"))
    $parent = $($(link).data("parent-selector"))
    $new_el = $parent.append($new_html)
  else
    if $parent = $(link).parents(".well").find("ul")
      $new_el = $parent.append($new_html)
    else
      $parent = $(link).parent()
      $new_el = $parent.before($new_html)

  $func = $(link).data("do-after-add")
  if $func
    eval "$(link).#{$func}"

  $callback = $(link).data("callback-after")
  if $callback
    eval "#{$callback}"

$ ->

  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

  bind_clearable_fields()
  bind_filter_html_elements()
  bind_button_urls()
  bind_datepicker()

  $(".sortable").bind_sortable()

  $("[data-counter='true']").bind_counter()
  $("[placeholder]").addClass("placeholder")

  $(".form-vertical").removeClass("form-horizontal")

  $("[data-nicedit]").each ->
    new nicEditor().panelInstance($(@).attr("id"))

  $("[data-checkboxes-clone]").each ->
    $(@).bind_checkboxes_clone()
  $("[data-collapsible-label]").each ->
    $(@).bind_collapsible_label()

  $("[data-boolean-value]").each ->
    $(@).bind_boolean_value()

  $("[data-ransack-btn]").each ->
    $(@).bind_ransack_btn()

  $("[data-ransack-chk]").each ->
    $(@).bind_ransack_chk()


  $("[data-active-select]").each ->
    $url = $(@).data("active-select")
    $(@).on
      change: ->
        $to_url = $url.replace /__template__/, $(@).val()
        window.location = $to_url

  $("[data-reset-form]").on
    click: ->
      $(@).parents("form").find("input[type='text'], textarea, select, input[type='password']").val("")
      false

  $("[data-token-input]").each ->
    $(@).tokenInput $(@).data("token-input"),
      theme: "facebook"
      prePopulate: $(@).data("token-pre")
      preventDuplicates: true
      crossDomain: false
      hintText: $(@).data("token-hint-text")
      noResultsText: $(@).data("token-no-results-text")
      searchingText: $(@).data("token-searching-text")

  $("#flash_panel").delay(3000).fadeOut 3000

