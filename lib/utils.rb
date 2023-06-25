# frozen_string_literal: true

Product = Struct.new(:name, :price, :old_price, :link, :created_at, keyword_init: true)
