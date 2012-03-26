" A ref source for godoc.
" Version: 0.0.1
" Author : mattn <mattn.jp@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

let s:languages = {
\ "bc": "110",
\ "clojure": "111",
\ "javascript:spidermonkey": "112",
\ "go": "114",
\ "unlambda": "115",
\ "python3": "116",
\ "r": "117",
\ "cobol:opencobol": "118",
\ "oz": "119",
\ "perl6": "54",
\ "cpp": "1",
\ "pascal:gpc": "2",
\ "perl": "3",
\ "python": "4",
\ "fortran": "5",
\ "whitespace": "6",
\ "ada": "7",
\ "ocaml": "8",
\ "intercal": "9",
\ "nemerle": "30",
\ "lisp": "32",
\ "scheme": "33",
\ "c": "34",
\ "javascript:rhino": "35",
\ "erlang": "36",
\ "tcl": "38",
\ "scala": "39",
\ "groovy": "121",
\ "nimrod": "122",
\ "factor": "123",
\ "fsharp": "124",
\ "falcon": "125",
\ "text": "62",
\ "java": "10",
\ "c:gcc": "11",
\ "brainfuck": "12",
\ "asm:nasm": "13",
\ "clips": "14",
\ "prolog:swi": "15",
\ "icon": "16",
\ "ruby": "17",
\ "pike": "19",
\ "vbnet": "101",
\ "d": "102",
\ "awk:gawk": "104",
\ "awk:nawk": "105",
\ "cobol:tinycobol": "106",
\ "forth": "107",
\ "prolog:gnu": "108",
\ "asm:gcc": "45",
\ "haskell": "21",
\ "pascal:fpc": "22",
\ "smalltalk": "23",
\ "nice": "25",
\ "lua": "26",
\ "csharp": "27",
\ "sh": "28",
\ "php": "29",
\}

let s:results = {
\ "0": "not running",
\ "11": "compilation error",
\ "12": "runtime error",
\ "13": "time limit exceeded",
\ "15": "success",
\ "17": "memory limit exceeded",
\ "19": "illegal system call",
\ "20": "internal error",
\}

function! ideone#testFunction(ideone_user, ideone_pass)
  let envelope = xml#createElement("soap:Envelope")
  let envelope.attr["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/"
  let envelope.attr["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"

  let body = xml#createElement("soap:Body")
  call add(envelope.child, body)
  let testFunction = xml#createElement("testFunction")
  call add(body.child, testFunction)

    let user = xml#createElement("user")
    let user.attr["xsi:type"] = "xsd:string"
    call user.value(a:ideone_user)
    call add(testFunction.child, user)

    let pass = xml#createElement("pass")
    let pass.attr["xsi:type"] = "xsd:string"
    call pass.value(a:ideone_pass)
    call add(testFunction.child, pass)

  let str = '<?xml version="1.0" encoding="UTF-8"?>' . envelope.toString()
  let res = http#post("http://ideone.com/api/1/service", str)
  let dom = xml#parse(res.content)
  let ret = {}
  for item in dom.findAll("item")
    let ret[item.find("key").value()] = item.find("value").value()
  endfor
  return ret
endfunction

function! ideone#getLanguages(ideone_user, ideone_pass)
  let envelope = xml#createElement("soap:Envelope")
  let envelope.attr["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/"
  let envelope.attr["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"

  let body = xml#createElement("soap:Body")
  call add(envelope.child, body)
  let getLanguages = xml#createElement("getLanguages")
  call add(body.child, getLanguages)

    let user = xml#createElement("user")
    let user.attr["xsi:type"] = "xsd:string"
    call user.value(a:ideone_user)
    call add(getLanguages.child, user)

    let pass = xml#createElement("pass")
    let pass.attr["xsi:type"] = "xsd:string"
    call pass.value(a:ideone_pass)
    call add(getLanguages.child, pass)

  let str = '<?xml version="1.0" encoding="UTF-8"?>' . envelope.toString()
  let res = http#post("http://ideone.com/api/1/service", str)
  let dom = xml#parse(res.content)
  let ret = {}
  for item in dom.findAll("item")
    let ret[item.find("key").value()] = item.find("value").value()
  endfor
  return ret
endfunction

function! ideone#createSubmission(ideone_user, ideone_pass, sourceCode, language, input, run, private)
  let envelope = xml#createElement("soap:Envelope")
  let envelope.attr["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/"
  let envelope.attr["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
  let body = xml#createElement("soap:Body")

    call add(envelope.child, body)
    let createSubmission = xml#createElement("createSubmission")
    call add(body.child, createSubmission)

    let user = xml#createElement("user")
    let user.attr["xsi:type"] = "xsd:string"
    call user.value(a:ideone_user)
    call add(createSubmission.child, user)

    let pass = xml#createElement("pass")
    let pass.attr["xsi:type"] = "xsd:string"
    call pass.value(a:ideone_pass)
    call add(createSubmission.child, pass)

    let sourceCode = xml#createElement("sourceCode")
    let sourceCode.attr["xsi:type"] = "xsd:string"
    call sourceCode.value(a:sourceCode)
    call add(createSubmission.child, sourceCode)

    let language = xml#createElement("language")
    let language.attr["xsi:type"] = "xsd:integer"
    call language.value(a:language)
    call add(createSubmission.child, language)

    let inpu = xml#createElement("input")
    let inpu.attr["xsi:type"] = "xsd:string"
    call inpu.value(a:input)
    call add(createSubmission.child, inpu)

    let run = xml#createElement("run")
    let run.attr["xsi:type"] = "xsd:boolean"
    call run.value(a:run ? "true" : "false")
    call add(createSubmission.child, run)

    let private = xml#createElement("private")
    let private.attr["xsi:type"] = "xsd:boolean"
    call private.value(a:private ? "true" : "false")
    call add(createSubmission.child, private)

  let str = '<?xml version="1.0" encoding="UTF-8"?>' . envelope.toString()
  let res = http#post("http://ideone.com/api/1/service", str)
  let dom = xml#parse(res.content)
  let ret = {}
  for item in dom.findAll("item")
    let ret[item.find("key").value()] = item.find("value").value()
  endfor
  return ret
endfunction

function! ideone#getSubmissionStatus(ideone_user, ideone_pass, link)
  let envelope = xml#createElement("soap:Envelope")
  let envelope.attr["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/"
  let envelope.attr["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
  let body = xml#createElement("soap:Body")

    call add(envelope.child, body)
    let getSubmissionStatus = xml#createElement("getSubmissionStatus")
    call add(body.child, getSubmissionStatus)

    let user = xml#createElement("user")
    let user.attr["xsi:type"] = "xsd:string"
    call user.value(a:ideone_user)
    call add(getSubmissionStatus.child, user)

    let pass = xml#createElement("pass")
    let pass.attr["xsi:type"] = "xsd:string"
    call pass.value(a:ideone_pass)
    call add(getSubmissionStatus.child, pass)

    let link = xml#createElement("link")
    let link.attr["xsi:type"] = "xsd:string"
    call link.value(a:link)
    call add(getSubmissionStatus.child, link)

  let str = '<?xml version="1.0" encoding="UTF-8"?>' . envelope.toString()
  let res = http#post("http://ideone.com/api/1/service", str)
  let dom = xml#parse(res.content)
  let ret = {}
  for item in dom.findAll("item")
    let ret[item.find("key").value()] = item.find("value").value()
  endfor
  return ret
endfunction

function! ideone#getSubmissionDetails(ideone_user, ideone_pass, link, withSource, withInput, withOutput, withStderr, withCmpinfo)
  let envelope = xml#createElement("soap:Envelope")
  let envelope.attr["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/"
  let envelope.attr["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
  let body = xml#createElement("soap:Body")

    call add(envelope.child, body)
    let getSubmissionDetails = xml#createElement("getSubmissionDetails")
    call add(body.child, getSubmissionDetails)

    let user = xml#createElement("user")
    let user.attr["xsi:type"] = "xsd:string"
    call user.value(a:ideone_user)
    call add(getSubmissionDetails.child, user)

    let pass = xml#createElement("pass")
    let pass.attr["xsi:type"] = "xsd:string"
    call pass.value(a:ideone_pass)
    call add(getSubmissionDetails.child, pass)

    let link = xml#createElement("link")
    let link.attr["xsi:type"] = "xsd:string"
    call link.value(a:link)
    call add(getSubmissionDetails.child, link)

    let withSource = xml#createElement("withSource")
    let withSource.attr["xsi:type"] = "xsd:boolean"
    call withSource.value(a:withSource ? "true" : "false")
    call add(getSubmissionDetails.child, withSource)

    let withInput = xml#createElement("withInput")
    let withInput.attr["xsi:type"] = "xsd:boolean"
    call withInput.value(a:withInput ? "true" : "false")
    call add(getSubmissionDetails.child, withInput)

    let withOutput = xml#createElement("withOutput")
    let withOutput.attr["xsi:type"] = "xsd:boolean"
    call withOutput.value(a:withOutput ? "true" : "false")
    call add(getSubmissionDetails.child, withOutput)

    let withStderr = xml#createElement("withStderr")
    let withStderr.attr["xsi:type"] = "xsd:boolean"
    call withStderr.value(a:withStderr ? "true" : "false")
    call add(getSubmissionDetails.child, withStderr)

    let withCmpinfo = xml#createElement("withCmpinfo")
    let withCmpinfo.attr["xsi:type"] = "xsd:boolean"
    call withCmpinfo.value(a:withCmpinfo ? "true" : "false")
    call add(getSubmissionDetails.child, withCmpinfo)

  let str = '<?xml version="1.0" encoding="UTF-8"?>' . envelope.toString()
  let res = http#post("http://ideone.com/api/1/service", str)
  let dom = xml#parse(res.content)
  let ret = {}
  for item in dom.findAll("item")
    let ret[item.find("key").value()] = item.find("value").value()
  endfor
  return ret
endfunction

function! ideone#getLangIds(name)
  if has_key(s:languages, a:name)
    return [s:languages[a:name]]
  else
    let c = []
    for key in keys(s:languages)
      if key[:len(a:name)-1] == a:name
        call add(c, key)
      endif
    endfor
    return c
  endif
endfunction

function! ideone#getResultMeaning(value)
  if has_key(s:results, a:value)
    return s:results[a:value]
endfunction

function! ideone#waitRunning(ideone_user, ideone_pass, link)
  let l:status = 1
  while l:status
    sleep 1
    let l:res = ideone#getSubmissionStatus(a:ideone_user, a:ideone_pass, a:link)
    if res["error"] == "OK"
      let l:status = l:res["status"]
    endif
  endwhile
endfunction

function! ideone#openOutputBuffer(ideone_user, ideone_pass, link)
  let res = ideone#getSubmissionDetails(a:ideone_user, a:ideone_pass, a:link, 0, 1, 1, 1, 1)
  if has_key(res, "error")
    if res["error"] == "OK"
      if !exists('s:bufnr')
        let s:bufnr = -1
      endif
      if !bufexists(s:bufnr)
        execute g:ideone_open_buffer_command
        edit `='[ideone output]'`
        let s:bufnr = bufnr('%')
      elseif bufwinnr(s:bufnr) != -1
        execute bufwinnr(s:bufnr) 'wincmd w'
      else
        execute g:ideone_open_buffer_command
        execute 'buffer' s:bufnr
      endif

      % delete _

      if res['cmpinfo'] != ''
        call append(line('$'), 'compilation info:')
        call append(line('$'), split(res['cmpinfo'], '\n'))
      endif

      call append(line('$'), join([
            \ 'result:'.ideone#getResultMeaning(res["result"]),
            \ 'time:'.res["time"],
            \ 'memory:'.res["memory"],
            \ 'returned value:'.res["signal"],
            \ ], "  "))

      call append(line('$'), 'output:')
      call append(line('$'), split(res['output'], '\n'))

      if res['stderr'] != ''
        call append(line('$'), 'stderr:')
        call append(line('$'), split(res['stderr'], '\n'))
      endif

      1 delete _
      setlocal nomodified
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
