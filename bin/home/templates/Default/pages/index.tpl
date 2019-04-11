<_include=all title="Books">
	<_Books>
		<table class="books">
			<tr>
				<td>Title <a href="/title/asc">^</a> <a href="/title/desc">v</a></td>
				<td>Author <a href="/author/asc">^</a> <a href="/author/desc">v</a></td>
				<td>Description <a href="/description/asc">^</a> <a href="/description/desc">v</a></td>
				<td>Image</td>
				<td></td>
			</tr>
			<_many>
				<tr><td>%title%</td><td>%author%</td><td>%description%</td><td><img src="%image%"/></td><td><a href="/editbook/%id%"">edit</a></td></tr>
			</_many>
		</table>
		%include=mEmpty%
		<_insert auto fix=author>New book</_insert>
	</_Books>
</_include>