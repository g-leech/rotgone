# rotgone : Internet Archive your links or rot in posterity

The average hyperlinked page is available for less than 100 days. So a notable fraction of the context and value of published web content is decaying over every short time frame.

`rotgone` finds and replaces links in your files: it substitutes in the Internet Archive (IA) link, adding the page to IA if it isn’t yet archived. There’s a node CLI and there will be a client-side rewriter in vanilla JS. Maybe a browser plugin, as a doomed outreach attempt.

 

## Usage

 
### CLI

```
\# Look in a file for links,
`rotgone /path/to/file.html`

\# Archive a whole site
`rotgone /path/to/whole/site/posts `

\# Update all linked pages in `file` on the Internet Archive:
`rotgone --rearchive /path/to/file.html`
```

#### Options

* `--rearchive`. Searches input file for links and saves the current version of all linked pages to IA, even if there before.

* `--rerot`. Removes IA links, thus returning the page to original vulnerable links.

* `--dryrun`.

* `--longen`. expand shortened links, replace with original or archive

  

### Client-side

Just add rotgone.js in your code like so:

```
 <script src="/js/rotgone-passive.js"></script>
```
On page load it will fire a request and rewrite your `hrefs` with IA. 

(The IA's page-save service is slow, bless them, ~10s per page: try it yourself: "http://web.archive.org/save/{your url}".)


 

 

### Development Schedule

 
#### v1 : rotgone-cli

(node cli for running on your site source before build.)

* v 0 : Write tests.
* v 0.1.1 : Functioning command line. Looks up all links over API, replaces if hit found. HTML input.
* v 0.1.2 : Add Mdown support.
* v 0.1.3 : Add whole folder support.
* v 0.2.1 : Add flag: `-d`, `--drydrun`
* v 0.2.2 : Add flag: `-h`, `--help`
* v 0.2.3 : Add flag: `-r`, `--rearchive`
* v 0.2.4 : Add flag: `-rf`, `--rerot`
* v 0.2.5 : Add flag: `-l`, `--longen`
* v 0.3 : Add progress report: “m/n checked”.
* v 1.0 : apt or npm package
 
#### v2 : rotgone

(js script)

* v 1.1 : passive client-side version: rewrite links on load
* v 1.2 : active client: save all
* v 1.3 : clever toggling
* v 2.0 : spread the word
 

#### v3 : rotgone-browser

(Browser plugin tuned for Blogger and Wordpress post editors.)
 