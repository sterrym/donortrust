@get_involved = Page.find_or_initialize_by_permalink_and_parent_id("get-involved", nil)
@get_involved.title = "Get Involved"
@get_involved.content = %Q(<p>Support the movement! There are many different ways to get involved with UEnd.</p> \n<h2>Your Mind</h2> \n<p>Stay knowledgeable about what we are doing.</p> \n<ul> \n<li>Sign up for <a href="http://www.industrymailout.com/Industry/Subscribe.aspx?m=3929">our newsletter</a></li> \n<li>Subscribe to <a href="http://feeds.feedburner.com/christmasfuture">our blog RSS</a></li> \n<li>Follow us on <a href="http://twitter.com/UEnd_org" title="http://twitter.com/UEnd_org">Twitter</a></li> \n<li>Become our fan on <a href="http://www.facebook.com/home.php#/pages/UEnd/15963191526" title="http://www.facebook.com/group.php?gid=3362029547">Facebook</a>.</li> \n</ul> \n<h2>Your Voice</h2> \n<ul> \n<li><a href="/dt/tell_friends/new">Share UEnd</a> with your family, friends, workmates, classmates, and everyone you meet about this unique opportunity for people like us to begin to change the world…for good!</li> \n<li>Approach your friends or office and inquire about using UEnd instead of doing a secret Santa or gift exchange this year.</li> \n<li>Add the UEnd footer to your email signature this year:<br /> \n<strong><em>Holiday gift purchasing can eradicate extreme poverty.<br /> \nExperience a new way to give</em>. <a href="/">www.uend.org</a></strong></li> \n<li><a href="/get-involved/resources/">UEnd posters</a> are here! Download them and put them up around your community, in your school, at you local coffeehouse or public house!</li> \n<li>Write a blog post or create a YouTube video about UEnd and why you support it</li> \n<li>Share our <a href="http://www.youtube.com/user/uendfoundation">YouTube videos</a> with your friends!</li> \n</ul> \n<div id="vvq4e4fbb9688c66" class="vvqbox vvqyoutube" style="width:425px;height:355px;"> \n<p><a href="http://www.youtube.com/watch?v=7fnicAxULBU">http://www.youtube.com/watch?v=7fnicAxULBU</a></p> \n</div> \n<div id="vvq4e4fbb9688d89" class="vvqbox vvqyoutube" style="width:425px;height:355px;"> \n<p><a href="http://www.youtube.com/watch?v=L9YXqZZaelY">http://www.youtube.com/watch?v=L9YXqZZaelY</a></p> \n</div> \n<h2>Your Wallet</h2> \n<ul> \n<li>You can support us <a href="/dt/projects/10">directly through our website</a>.</li> \n</ul>)
@get_involved.save
Page.create(:title => "Volunteer", :parent => @get_involved, :content => %Q(<p>If you are interested in volunteering with UEnd but don&rsquo;t see a position listed below that makes sense for you, contact our Volunteer Coordinator at <a href="mailto:info@uend.org">info@uend.org</a>. We strive to find meaningful work for anyone who is interested in helping out.</p> \n<p><strong>IMMEDIATE NEEDS:</strong></p> \n<p><strong><em>Graphic Artists/Designers</em></strong></p> \n<p>&bull; UEnd requires individuals with a background in both graphic design and print media to assist in the design of marketing, communications and educational materials. The individual(s) will collaborate with other UEnd teams to ensure consistent messaging for the organization.<br /> \n&bull; Email us at <a href="mailto:info@uend.org">info@uend.org</a> if this role interests you or if you&rsquo;d like more information</p> \n<p><strong><em>Social Media Fanatics</em></strong></p> \n<p>&bull; We require individuals with a background in social media (Facebook, Twitter, YouTube, Linked In) to participate and engage in social media for UEnd. The social media fan will with a team of similar folks to create excitement, drive social media users to our channels and build momentum around UEnd as the place to go to change the world one gift at a time. Background in social media use is preferred.<br /> \n&bull; Email us at <a href="mailto:info@uend.org">info@uend.org</a> if this role interests you or if you&rsquo;d like more information</p> \n<p><strong><em>Social Community Manager</em></strong></p> \n<p>&bull; UEnd is searching for a person with a keen understanding of how to use social media to build excitement and momentum around a cause - UEnd. This person will work with a group of social media fanatics.<br /> \n&bull; Ideally this person has a marketing or social media background, perhaps in interactive media.  This person would need to be comfortable taking the lead on this project. They will be required to develop a plan, report to the Operations Manager, then work with the team to make it happen.<br /> \n&bull; Email us at <a href="mailto:info@uend.org">info@uend.org</a> if this role interests you or if you&rsquo;d like more information.</p> \n<p><strong>VOLUNTEER TEAM:</strong></p> \n<p><strong><em>Promotions Team members</em></strong></p> \n<p>&bull; UEnd is looking for great people to assist in spreading the word at public events about UEnd and its mission.  Events occur over the course of the year.  This team is also responsible for planning the volunteer Jams held quarterly.  This person would need to be someone who loves to be out talking to people and can &ldquo;work a room.&rdquo;<br /> \n&bull; Email us at <a href="mailto:info@uend.org">info@uend.org</a> if this role interests you or if you&rsquo;d like more information</p>))

@school_program = Page.find_or_initialize_by_permalink_and_parent_id("school-program", nil)
@school_program.title = "School Program"
@school_program.content = %Q(<p>Extreme poverty could end in your lifetime. Educate and empower your students.</p> \n<p>UEnd: invites you to join schools across Canada to educate students about global citizenship and extreme poverty.</p> \n<p>Use UEnd:&#8217;s free, downloadable curriculum and resources to engage grade 1-9 social studies students to make a tangible difference in the world. Pair strong curriculum with powerful online tools to give your students a lasting educational experience.</p> \n<p>Lessons are accompanied by additional resources, such as letters to parents, and online videos from on-the-ground development agencies, to make it easy for teachers to use our curriculum.</p> \n<p>Please note the current curriculum is in the process of being updated through a partnership with Nexen inc. Grades 1-7 will be posted by Sept 2011. It will be an inquiry based approach to learning covering all subjects applicable to global citizenship.</p> \n<p>Have more questions about the school program? See our <a href="/school-program/faqs/">FAQs page</a>.</p>)
@school_program.save
Page.create(:title => "FAQs", :parent => @school_program, :content => %Q(<p><strong>Who designed the School Program Curriculum?</strong></p> \n<ul> \n<li>The UEnd curriculum has benefited from many volunteer teachers and educators who have helped develop the curriculum. They have specifically aided making the lessons grade UEnd to make the lesson plans as accessible as possible, in simple and flexible downloadable format.\n<li>Many of the original lesson plans have been amalgamated from various existing sources such as Sharing the Harvest – <a href="http://www.cic.gc.ca/english/citizen/celebrate.html">A Year-Round Activity Guide about Global Citizenship</a> (2005), created by the Citizenship and Immigration Canada.\n</ul> \n<p><strong>How is the School Program curriculum different from other global curriculums offered online?</strong><br /> \nOur curriculum is another great resource that is available to educators. It is extremely simple to access and has been tailored to grade-specific learning outcomes. It can easily complement and build upon other existing online lesson plans.</p> \n<p><strong>What are the topics of individual lessons?</strong><br /> \nThe topics covered vary slightly from grade to grade, as not all subjects are appropriate for all learning levels. All of the lesson plans however do maintain a consistent overall arch in creating awareness of extreme poverty and global citizenship. Specific topics include global citizenship, definitions of poverty, lifestyle comparisons (“If the world were a village”), millennium development goals, HIV/AIDS, and models of development.  </p> \n<p><strong>Does the curriculum require additional resources?</strong><br /> \nAll of the lesson plans are available for free download at www.christmasfuture.org in PDF format. They can be downloaded in a complete set all together, or teachers can pick and choose which lessons to download. There are no special resources required by the lessons themselves. </p> \n<p><strong>Does the curriculum require in-class used of the UEnd website?</strong><br /> \nNo. Lesson plans can be downloaded, printed, and then taught in class.</p> \n<p><strong>Can a teacher use the curriculum individually or does it have to be done as a school?</strong><br /> \nThe curriculum is entirely flexible and can be implemented by as many classes/teachers as need be. The curriculum structure does not restrict how many people/classes are involved. </p> \n<p><strong>Will the curriculum be available throughout the year?</strong><br /> \nYes! Although we encourage teacher’s to join with other schools by participating during the holiday season and/or in End Poverty Week, the curriculum is available year-round.</p> \n<p><strong>Who else is using the School Program curriculum?</strong><br /> \nWe have piloted this curriculum at the Calgary Science School in 2006 and 2007. It is offered to any instructor that wishes to use it and the curriculum has been downloaded by teachers in Calgary, nationally, and internationally. </p> \n<p><strong>How does this curriculum meet criteria from Alberta Education?</strong><br /> \nWhile the learning objectives meet established citizenship goals under the social studies curriculum, we believe that teachers will be able to apply the lesson plans in many areas. Creating global citizens and ending poverty are truly multi-disciplinary endeavours.</p> \n<p><strong>How does this curriculum meet criteria set by the Calgary Board of Education?</strong><br /> \nThe Calgary Board of Trustee’s has established Citizenship as one of its educational “ends” and encourages the development of responsible citizens who are informed and involved in their local, national, and global communities.</p> \n<h2>Other Resources</h2> \n<p><a href="http://www.un.org/cyberschoolbus%20">www.un.org/cyberschoolbus<br /> \n</a><a href="http://www.millenniumpromise.org/">www.millenniumpromise.org</a><br /> \n<a href="http://www.earthinstitute.columbia.edu/mvp/">www.earthinstitute.columbia.edu/mvp/</a><br /> \n<a href="http://www.youthnoise.org/">www.youthnoise.org</a><br /> \n<a href="http://www.givemeaning.com/">www.givemeaning.com</a><br /> \n<a href="http://www.one.org/">www.one.org</a><br /> \n<a href="http://www.metowe.org/">www.metowe.org</a></p>))
