// RestaurantMenu.js
import React, { useState, useEffect } from 'react';
import './RestaurantMenu.css';
import { Utensils } from 'lucide-react';

export default function RestaurantMenu() {
  const [menuItems, setMenuItems] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState('all');

  // ... rest of your fetch logic ...

  return (
    <div className="page-container">
      <header className="restaurant-header">
        <h1 className="restaurant-title">Golden Dragon</h1>
        <div className="restaurant-subtitle">
          <Utensils />
          <span>Authentic Chinese Cuisine</span>
        </div>
      </header>

      <div className="menu-container">
        <nav className="category-nav">
          {categories.map(category => (
            <button
              key={category}
              onClick={() => setSelectedCategory(category)}
              className={`category-button ${selectedCategory === category ? 'active' : ''}`}
            >
              {category.charAt(0).toUpperCase() + category.slice(1)}
            </button>
          ))}
        </nav>

        <div className="menu-grid">
          {filteredItems.map(item => (
            <div key={item.menu_item_id} className="menu-item">
              <img
                src={`/api/placeholder/400/300`}
                alt={item.item_name}
                className="menu-item-image"
              />
              <div className="menu-item-content">
                <div className="menu-item-header">
                  <h3 className="menu-item-title">{item.item_name}</h3>
                  <span className="menu-item-price">${item.price}</span>
                </div>
                <p className="menu-item-category">{item.type_of_menu_item}</p>
                {item.quantity < 10 && (
                  <p className="low-stock">Only {item.quantity} left!</p>
                )}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}