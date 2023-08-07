module Auth

	def image_url(user)
    user&.image&.url
  end
end
