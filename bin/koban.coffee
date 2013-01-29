sqlite3 = require '../node_modules/sqlite3'

{inspect} = require 'util'
{log, error} = console

db = new sqlite3.Database '/home/dan/Desktop/KoboReader.sqlite', sqlite3.OPEN_READONLY, (err)->
  return error err if err

md = ""

db.all "select book.contentid as bookid, book.title as title, c.title as chapter, b.bookmarkid as bookmarkid, b.text as text, b.annotation as annotation 
from bookmark b 
inner join content c on b.contentid = c.contentid 
inner join content book on c.bookid = book.contentid 
order by book.datelastread desc, b.datecreated", (err, rows)->
  return error err if err?
  #console.log inspect(rows)

  title = null
  chapter = null
  rows.forEach (row)->
    # Display title
    if title != row.title
      md += "# #{row.title}\n\n" 
      title = row.title

    # Display chapter
    if chapter != row.chapter
      md += "## #{row.chapter}\n\n" 
      chapter = row.chapter

    # Display annotation
    md += "#{row.text}\n\n"

  log md

db.close()