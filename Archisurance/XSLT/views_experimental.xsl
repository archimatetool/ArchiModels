<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:arc="http://www.opengroup.org/xsd/archimate"
	xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	
<xsl:template name="svg_node">
	<xsl:for-each select="arc:node">
		<xsl:variable name="svg_x" select="@x"/>
		<xsl:variable name="svg_y" select="@y"/>
		<xsl:variable name="svg_w" select="@w"/>
		<xsl:variable name="svg_h" select="@h"/>
		<xsl:variable name="svg_fill_r" select="arc:style/arc:fillColor/@r"/>
		<xsl:variable name="svg_fill_g" select="arc:style/arc:fillColor/@g"/>
		<xsl:variable name="svg_fill_b" select="arc:style/arc:fillColor/@b"/>
		<xsl:variable name="svg_stroke_r" select="arc:style/arc:lineColor/@r"/>
		<xsl:variable name="svg_stroke_g" select="arc:style/arc:lineColor/@g"/>
		<xsl:variable name="svg_stroke_b" select="arc:style/arc:lineColor/@b"/>
		<xsl:variable name="svg_fill" select="concat('fill:rgb(', $svg_fill_r, ',', $svg_fill_g, ',', $svg_fill_b, ');')"/>
		<xsl:variable name="svg_stroke" select="concat('stroke:rgb(', $svg_stroke_r, ',', $svg_stroke_g, ',', $svg_stroke_b, ');')"/>
		<xsl:variable name="svg_style" select="concat($svg_fill, 'stroke-width:1;', $svg_stroke)"/>
		
		<xsl:variable name="ElementRef" select="concat('',@elementref,'')"></xsl:variable>
		<xsl:variable name="svg_text" select="//arc:element[@identifier=$ElementRef]/arc:label"/>
		
		<svg:rect x="{$svg_x}" y="{$svg_y}" width="{$svg_w}" height="{$svg_h}" style="{$svg_style}" />
		<svg:text x="{$svg_x+5}" y="{$svg_y+15}" font-size="12"><xsl:value-of select="$svg_text"/></svg:text>
		
		<xsl:call-template name="svg_node"/>
	</xsl:for-each>
</xsl:template>

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
		
    <h2>Views in the model</h2>

	<table class="border">
		<tr style="text-align:left;">
			<th>Id</th>
			<th>Name</th>
		</tr>
		<xsl:for-each select="arc:model/arc:views/arc:view">
			<tr>
				<td class="border"><xsl:value-of select="@identifier"/></td>
				<td class="border"><xsl:value-of select="arc:label"/></td>
			</tr>
		</xsl:for-each>
	</table>

	<xsl:for-each select="//arc:view">
    	<xsl:variable name="id" select="@identifier"></xsl:variable>
		<p><a name="{$id}"><xsl:value-of select="arc:label"/></a></p>
		<svg:svg width="1000" height="1500">
			<xsl:call-template name="svg_node"/>
		</svg:svg>
	</xsl:for-each>
	
  </body>
</html>

</xsl:template>
</xsl:stylesheet>