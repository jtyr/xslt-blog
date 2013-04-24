<?xml version="1.0" encoding="utf-8"?>


<!--
  **********************************************************
  ** Description: Article list template
  **
  ** (c) Jiri Tyr 2007-2008
  **********************************************************
  -->

<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">


<!-- includes -->
<xsl:include href="Setting.xsl"/>
<xsl:include href="Lang.xsl"/>
<xsl:include href="Category.xsl"/>
<xsl:include href="Utils.xsl"/>
<xsl:include href="HTMLPieces.xsl"/>


<!-- input param -->
<xsl:param name="date"/>


<!-- main template -->
<xsl:template match="/">
	<!-- print header -->
	<xsl:call-template name="getHeader">
		<xsl:with-param name="html" select="'index'"/>
		<xsl:with-param name="date" select="$date"/>
	</xsl:call-template>

	<!-- category menu -->
	<div id="MenuPanel">
		<div class="Menu">
			<div class="Title"><a href="index.html"><xsl:call-template name="getText"><xsl:with-param name="id" select="'categories'"/></xsl:call-template></a></div>
			<div class="Body">
				<xsl:call-template name="getCategoryTree">
					<xsl:with-param name="cat" select="document('../xml/CategoryList.xml')/category_list/category"/>
				</xsl:call-template>
			</div>
		</div>

		<!-- quick links menu -->
		<xsl:if test="/article_list/a[@q]">
			<div class="Menu">
				<div class="Title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'quick_links'"/></xsl:call-template></div>
				<div class="Body">
					<ul>
						<xsl:for-each select="/article_list/a">
							<xsl:sort select="./@q"/>

							<xsl:if test="./@q">
								<xsl:variable name="a_href">
									<xsl:choose>
										<xsl:when test="string-length($date) > 0">
											<xsl:value-of select="concat('article.html?article=', ./@i, '&amp;page=', $page, '&amp;date=', $date)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="concat('article.html?article=', ./@i, '&amp;page=', $page, '&amp;category=', $category)"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<li><a href="{$a_href}"><xsl:value-of select="document(concat('../xml/articles/Article-', @i, '.xml'))/article/title"/></a></li>
							</xsl:if>
						</xsl:for-each>
					</ul>
				</div>
			</div>
		</xsl:if>

		<!-- calendar menu -->
		<div class="Menu">
			<div class="Title"><xsl:call-template name="getText"><xsl:with-param name="id" select="'calendar'"/></xsl:call-template></div>
			<div id="Calendar" class="Body"><span style="color: silver;"><xsl:call-template name="getText"><xsl:with-param name="id" select="'loading_calendar'"/></xsl:call-template></span></div>
		</div>
	</div>

	<!-- articles list -->
	<div id="List">
		<xsl:variable name="catstring">
			<xsl:call-template name="getCategoryString">
				<xsl:with-param name="cat" select="document('../xml/CategoryList.xml')/category_list//category[@id=$category]"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="string-length($date) > 0">
				<xsl:call-template name="getListStruct">
					<xsl:with-param name="struct" select="/article_list/a[c and contains(@d, concat(substring($date,7,2), '.', substring($date,5,2), '.', substring($date,1,4)))]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$category = 0">
				<xsl:call-template name="getListStruct">
					<xsl:with-param name="struct" select="/article_list/a[c]"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="getListStruct">
					<xsl:with-param name="struct" select="/article_list/a[c[contains($catstring, @i)]]"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</div>

	<br class="Clear"/>

	<script type="text/javascript">
		document.title = "<xsl:value-of select="$blog_name"/>";

		var dates = [<xsl:for-each select="/article_list/a[c]">'<xsl:value-of select="substring(@d,1,10)"/>',</xsl:for-each>''];
		for (var i=0; i&lt;dates.length-1; i++) {
			insertDate(dates[i].substring(6,10), dates[i].substring(3,5), dates[i].substring(0,2));
		}

		// define calendar
		getBrowserObject('Calendar').innerHTML = '';
		Calendar.setup({
			flat           : 'Calendar',
			flatCallback   : dateChanged,
			dateStatusFunc : ourDateStatusFunc,
			<xsl:if test="string-length($date) > 0">date           : '<xsl:value-of select="concat(substring($date,1,4), '/', substring($date,5,2), '/', substring($date,7,2))"/>',</xsl:if>
			firstDay       : 1
		});
	</script>

	<!-- print header -->
	<xsl:call-template name="getFooter"/>
</xsl:template>


<!-- print article list with given struct -->
<xsl:template name="getListStruct">
	<!-- input param -->
	<xsl:param name="struct"/>

	<xsl:variable name="nodes_number" select="count($struct)"/>

	<xsl:choose>
		<xsl:when test="$nodes_number = 0">
			<div class="Center Bold"><xsl:call-template name="getText"><xsl:with-param name="id" select="'list_no_articles'"/></xsl:call-template></div>
		</xsl:when>
		<xsl:otherwise>
			<div style="padding-bottom: 10px;">
				<span class="Bold"><xsl:call-template name="getText"><xsl:with-param name="id" select="'number_of_articles'"/></xsl:call-template></span><xsl:value-of select="$nodes_number"/>
			</div>
		</xsl:otherwise>
	</xsl:choose>


	<!-- Listing -->
	<xsl:call-template name="getListing">
		<xsl:with-param name="nodes_number" select="$nodes_number"/>
	</xsl:call-template>

	<xsl:if test="$nodes_number > $count">
		<br/>
	</xsl:if>

	<xsl:for-each select="$struct">
		<!-- sort all articles (the newer is the first) -->
		<xsl:sort select="concat(substring(@d, 7, 4), substring(@d, 4, 2), substring(@d, 1, 2), substring(@d, 12, 2), substring(@d, 15, 2),  substring(@d, 18, 2))" order="descending"/>

		<!-- variable used in function document -->
		<xsl:variable name="article_file" select="concat('../xml/articles/Article-', @i, '.xml')"/>
		<xsl:variable name="position" select="position()"/>

		<!-- print article list -->
		<xsl:call-template name="getList">
			<xsl:with-param name="cat_list" select="./c"/>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="article_file" select="$article_file"/>
			<xsl:with-param name="dte" select="@d"/>
		</xsl:call-template>
	</xsl:for-each>

	<!-- Listing -->
	<xsl:call-template name="getListing">
		<xsl:with-param name="nodes_number" select="$nodes_number"/>
	</xsl:call-template>
</xsl:template>


<!-- print listing -->
<xsl:template name="getListing">
	<!-- input param -->
	<xsl:param name="nodes_number"/>

	<!-- curent page number -->
	<xsl:variable name="page_total" select="floor($nodes_number div $count)+1"/>

	<xsl:if test="$nodes_number > $count">
		<form onsubmit="var n = Math.abs(Math.floor(page.value)); if (isNaN(n) || n > {$page_total}) return false;">
			<div class="Listing">
				<xsl:choose>
					<xsl:when test="$page > 1">
						<xsl:choose>
							<xsl:when test="string-length($date) > 0">
								<a href="index.html?date={$date}{'&amp;'}page={$page - 1}" title="Previous">&#8592;</a>
								<a href="index.html?date={$date}" title="First">&#171;</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="index.html?category={$category}{'&amp;'}page={$page - 1}" title="Previous">&#8592;</a>
								<a href="index.html?category={$category}" title="First">&#171;</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<span class="Fake">&#8592;</span>
						<span class="Fake">&#171;</span>
					</xsl:otherwise>
				</xsl:choose>

				<span class="Box"><xsl:call-template name="getText"><xsl:with-param name="id" select="'listing_page'"/></xsl:call-template><input type="text" name="page" value="{$page}" size="3"/>
				<xsl:call-template name="getText"><xsl:with-param name="id" select="'listing_page_of'"/></xsl:call-template><xsl:value-of select="$page_total"/>
				<xsl:text> </xsl:text>
				<xsl:variable name="listing_go"><xsl:call-template name="getText"><xsl:with-param name="id" select="'listing_go'"/></xsl:call-template></xsl:variable>
				<input type="submit" value="{$listing_go}"/>
				</span>

				<xsl:choose>
					<xsl:when test="$page != $page_total">
						<xsl:choose>
							<xsl:when test="string-length($date) > 0">
								<a href="index.html?date={$date}{'&amp;'}page={$page_total}" title="Last">&#187;</a>
								<a href="index.html?date={$date}{'&amp;'}page={$page + 1}" title="Next">&#8594;</a>
							</xsl:when>
							<xsl:otherwise>
								<a href="index.html?category={$category}{'&amp;'}page={$page_total}" title="Last">&#187;</a>
								<a href="index.html?category={$category}{'&amp;'}page={$page + 1}" title="Next">&#8594;</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<span class="Fake">&#187;</span>
						<span class="Fake">&#8594;</span>
					</xsl:otherwise>
				</xsl:choose>
			</div>
			<input type="hidden" name="category" value="{$category}"/>
		</form>
	</xsl:if>
</xsl:template>


<!-- print the article -->
<xsl:template name="getList">
	<!-- template input parameters -->
	<xsl:param name="cat_list"/>
	<xsl:param name="position"/>
	<xsl:param name="article_file"/>
	<xsl:param name="dte"/>

	<!-- variable used in <a> -->
	<xsl:variable name="article_href">
		<xsl:choose>
			<xsl:when test="string-length($date) > 0">
				<xsl:value-of select="concat('article.html?article=', @i, '&amp;page=', $page, '&amp;date=', $date)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('article.html?article=', @i, '&amp;page=', $page, '&amp;category=', $category)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- print "count" articles, begin on "page" -->
	<xsl:if test="$position >= (($page * $count) - $count + 1) and (($page * $count) + 1) > $position">
		<div class="Article">
			<!-- name of the article -->
			<h3>
				<a href="{$article_href}"><xsl:value-of select="document($article_file)/article/title"/></a>
			</h3>

			<!-- print some infos about the article -->
			<div class="Info">
				<b><xsl:call-template name="getText"><xsl:with-param name="id" select="'list_info_date'"/></xsl:call-template></b><xsl:value-of select="$dte"/>

				<xsl:if test="count($cat_list) > 0">
					<xsl:text>, </xsl:text><b><xsl:call-template name="getText"><xsl:with-param name="id" select="'list_info_category'"/></xsl:call-template></b>

					<xsl:call-template name="getCategoryNames">
						<xsl:with-param name="data" select="$cat_list"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="$show_lang_flag and document($article_file)/article[@lang] and document($article_file)/article/@lang != $lang">
					<xsl:variable name="flag" select="document('../xml/LangList.xml')/lang_list/lang[@id=document($article_file)/article/@lang]/@flag"/>
					<xsl:text>, </xsl:text><b><xsl:call-template name="getText"><xsl:with-param name="id" select="'list_article_lang'"/></xsl:call-template></b><img src="./design/flags/flag_{$flag}.png" width="21" height="14" alt="flag" style="vertical-align: bottom;"/>
				</xsl:if>
			</div>

			<!-- print article body -->
			<div class="Text">
				<xsl:choose>
					<!-- text have an abstract -->
					<xsl:when test="document($article_file)/article/text/abstract">
						 <xsl:copy-of select="document($article_file)/article/text/abstract"/>

						<div>[<a href="{$article_href}"><xsl:call-template name="getText"><xsl:with-param name="id" select="'list_read_more'"/></xsl:call-template></a>]</div>
					</xsl:when>

					<!-- text doesn't have the abstract, check its length -->
					<xsl:when test="string-length(document($article_file)/article/text) > $max_length">
						<!-- reverse string and cut off all characters after first space and reverse it back -->
						<xsl:variable name="rev">
							<xsl:call-template name="reverse">
								<xsl:with-param name="input" select="substring(document($article_file)/article/text, 1, $max_length)"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:variable name="text">
							<xsl:call-template name="reverse">
								<xsl:with-param name="input" select="substring-after($rev,' ')"/>
							</xsl:call-template>
						</xsl:variable>

						<xsl:value-of select="$text"/><xsl:text>...</xsl:text>

						<div>[<a href="{$article_href}"><xsl:call-template name="getText"><xsl:with-param name="id" select="'list_read_more'"/></xsl:call-template></a>]</div>
					</xsl:when>

					<!-- if the article is not so long -->
					<xsl:otherwise>
						<xsl:value-of select="document($article_file)/article/text"/>
					</xsl:otherwise>
				</xsl:choose>
			</div>

		</div>
	</xsl:if>
</xsl:template>


</xsl:transform>
