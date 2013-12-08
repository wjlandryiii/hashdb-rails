class Pager

	def initialize(itemCount, currentPage = 0, itemsPerPage = 20)
		@itemCount = itemCount.to_i();
		@currentPage = currentPage.to_i();
		@itemsPerPage = itemsPerPage.to_i();
	end

	def offset()
		@currentPage * @itemsPerPage
	end

	def limit()
		@itemsPerPage
	end

	def pageCount()
		@itemCount / @itemsPerPage + (@itemCount % @itemsPerPage == 0 ? 0 : 1)
	end

end