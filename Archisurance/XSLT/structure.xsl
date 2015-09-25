<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:arc="http://www.opengroup.org/xsd/archimate"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        
<xsl:template name="item_org">
    <xsl:for-each select="arc:item">
        <xsl:variable name="identifierref" select="concat('',@identifierref,'')"></xsl:variable>
        <xsl:variable name="label" select="//*[@identifier=$identifierref]/arc:label"></xsl:variable>
        <xsl:variable name="type" select="//*[@identifier=$identifierref]/@xsi:type"></xsl:variable>

        <xsl:choose>
            <xsl:when test="$label != ''">
                <ul><a href="#{$identifierref}"><xsl:value-of select="$label"/></a></ul>
            </xsl:when>
            <xsl:otherwise>
                <ul><a href="#{$identifierref}"><xsl:value-of select="$type"/></a></ul>
            </xsl:otherwise>
        </xsl:choose>

        <ul><xsl:value-of select="arc:label"/></ul>

        <ul><xsl:call-template name="item_org"/></ul>
    </xsl:for-each>    
</xsl:template>
	
<xsl:template match="/">
<html>
  
  <style>
    body {
        font-family: "Helvetica Neue", "Open Sans", Arial, sans-serif;
    }

    table {
        font-size: 15px;
        line-height: 1.3em;
    }

    table.border {
        border-collapse: collapse;
        border-spacing: 0;
    }

    td {
        padding: 5px;
        min-width: 100px;
    }

    td.border {
        border: 1px solid black;
        padding: 4px;
    }

  </style>
  
  <body>
    <h1><xsl:value-of select="arc:model/arc:name"/></h1>
    <p><xsl:value-of select="arc:model/arc:documentation"/></p>
	
    <h2>Structure</h2>

	<xsl:for-each select="arc:model/arc:organization">
        <xsl:call-template name="item_org"/>
	</xsl:for-each>

    <h2>Elements in the model</h2>
	
	<table class="border">
		<tr style="text-align:left;">
			<th>Id</th>
			<th>Name</th>
			<th>Documentation</th>
			<th>Type</th>
		</tr>
		<xsl:for-each select="arc:model/arc:elements/arc:element">
			<xsl:sort select="@xsi:type"/>
			<xsl:variable name="id" select="@identifier"/>
			<tr>
				<td class="border"><a name="{$id}"><xsl:value-of select="@identifier"/></a></td>
				<td class="border"><xsl:value-of select="arc:label"/></td>
				<td class="border"><xsl:value-of select="arc:documentation"/></td>
				<td class="border"><xsl:value-of select="@xsi:type"/></td>
			</tr>
		</xsl:for-each>
	</table>
		
    <h2>Relationships in the model</h2>
	
	<table class="border">
		<tr style="text-align:left;">
			<th>Id</th>
			<th>Name</th>
			<th>Source Element</th>
			<th>Target Element</th>
			<th>Type</th>
		</tr>
		<xsl:for-each select="arc:model/arc:relationships/arc:relationship">
			<xsl:sort select="@xsi:type"/>
			<xsl:variable name="Source" select="concat('',@source,'')"></xsl:variable>
			<xsl:variable name="Target" select="concat('',@target,'')"></xsl:variable>
			<xsl:variable name="id" select="@identifier"/>
			<tr>
				<td class="border"><a name="{$id}"><xsl:value-of select="@identifier"/></a></td>
				<td class="border"><xsl:value-of select="arc:label"/></td>
				<td class="border"><xsl:value-of select="//arc:element[@identifier=$Source]/arc:label"/></td>
				<td class="border"><xsl:value-of select="//arc:element[@identifier=$Target]/arc:label"/></td>
				<td class="border"><xsl:value-of select="@xsi:type"/></td>
			</tr>
		</xsl:for-each>
	</table>
	
  </body>
</html>

</xsl:template>
</xsl:stylesheet>