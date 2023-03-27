/-  *linedb
::
=,  format
=,  differ
|%
++  branch
  =|  [snaps=((mop index commit) lth) head=index]
  |%
  ::
  ::  write arms
  ::
  ++  commit
    |=  [author=ship new-snap=snapshot]
    ^+  branch
    %=    +>.$
        head   +(head)
        snaps
      %^  put:snap-on  snaps  +(head)
      :+  author
        new-snap
      ?:  =(0 head)  (build-diff ~ new-snap)
      (build-diff latest-snap new-snap)
    ==
  ::
  ++  set-head
    |=  new-head=@ud
    ^+  branch
    ?>  (has:snap-on snaps new-head)
    +>.$(head new-head)
  ::
  ::  read arms
  ::
  ++  get-commit     |=(i=index (got:snap-on snaps i))
  ++  get-diffs      |=(i=index diffs:(got:snap-on snaps i))
  ++  get-snap       |=(i=index snapshot:(got:snap-on snaps i))
  ++  get-diff       |=([i=index f=file-name] (~(got by (get-diffs i)) f))
  ++  get-file       |=([f=file-name i=index] (of-wain (~(got by (get-snap i)) f)))
  ++  latest-commit  (got:snap-on snaps head)
  ++  latest-diffs   diffs:(got:snap-on snaps head)
  ++  latest-snap    snapshot:(got:snap-on snaps head)
  ++  latest-diff    |=(f=file-name (get-diff head f))
  ++  latest-file    |=(f=file-name (of-wain (~(got by latest-snap) f)))
  ::
  :: for squashing commit N with commit N+1. To squash N commits you must call this N times
  :: copy +join from mar/txt/hoon (minimal edits)
  ++  squash  'todo'
  --
++  build-diff
  |=  [old=snapshot new=snapshot]
  ^-  (map path diff)
  %-  ~(urn by (~(uni by old) new))
  |=  [=path *]
  ^-  diff
  =/  a=file  ?~(got=(~(get by old) path) *file u.got)
  =/  b=file  ?~(got=(~(get by new) path) *file u.got)
  (lusk:differ a b (loss:differ a b))
::
++  line-mapping
  ::  TODO this function doesn't produce a map for any edited lines
  ::  we need a more advanced diff algo if we want to do that
  ::  one that can analyze individual lines
  |=  =diff
  ^-  (map line line)
  =|  iold=@ud
  =|  inew=@ud
  =|  new-lines=(list (pair line line))
  |-
  ?~  diff  (~(gas by *(map line line)) new-lines)
  ?-  -.i.diff
    %&  %=    $
            iold  (add iold p.i.diff)
            inew  (add inew p.i.diff)
            diff  t.diff
            new-lines
          |-
          ?:  =(0 p.i.diff)  new-lines
          %=  $
            new-lines  [[+(iold) +(inew)] new-lines]
            p.i.diff   (dec p.i.diff)
            iold       +(iold)
            inew       +(inew)
          ==
        ==
  ::
    %|  %=  $
          iold  (add iold (lent p.i.diff))
          inew  (add inew (lent q.i.diff))
          diff  t.diff
        ==
  ==
--
